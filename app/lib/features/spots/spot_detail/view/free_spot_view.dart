import 'dart:async';
import 'package:core/core.dart';
import 'package:facility/facility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sport_manager_mobile/app/app.dart';
import 'package:sport_manager_mobile/core/core.dart';
import 'package:sport_manager_mobile/features/auth/auth.dart';
import 'package:sport_manager_mobile/features/home/home.dart';
import 'package:sport_manager_mobile/features/spots/spots.dart';
import 'package:sport_manager_mobile/features/venues/venues.dart';
import 'package:sport_manager_mobile/l10n/l10n.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

class FreeSpotView extends StatefulWidget {
  const FreeSpotView({
    required this.spotCubit,
    required this.spot,
    super.key,
  });

  final SpotDetailCubit spotCubit;
  final SpotModel spot;

  @override
  State<FreeSpotView> createState() => _FreeSpotViewState();
}

class _FreeSpotViewState extends State<FreeSpotView> {
  late SpotModel _spot;
  late VenueType _venueType;

  @override
  void initState() {
    super.initState();
    _spot = widget.spot;
    _venueType = _resolveVenueType(context);
  }

  VenueType _resolveVenueType(BuildContext context) {
    final state = context.read<HomeCubit>().state;
    return switch (state) {
      HomeLoaded(:final venue) || HomeNoSpots(:final venue) => venue.type,
      _ => VenueType.billiards,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(_spot.name ?? context.l10n.homeSpotTitle(_venueType.spotLabel(context), _spot.number)),
        actions: [
          if (context.read<AuthCubit>().state.isOwner)
            AppEditDeleteMenu(
              onEdit: _onEdit,
              onDelete: _onDelete,
            ),
        ],
      ),
      body: BlocListener<SpotDetailCubit, SpotDetailState>(
        bloc: widget.spotCubit,
        listener: (context, state) {
          if (state is SpotDetailFree && state.startStatus.isFailure) {
            final exception = (state.startStatus as RequestFailure<SessionModel>).exception;
            context.handleError(exception);
          }
          if (state is SpotDetailOccupied) {
            unawaited(context.read<HomeCubit>().load());
          }
        },
        child: FreeSpotBody(_spot, venueType: _venueType),
      ),
      floatingActionButtonLocation: kAppButtonFabLocation,
      floatingActionButton: BlocBuilder<SpotDetailCubit, SpotDetailState>(
        bloc: widget.spotCubit,
        buildWhen: (p, c) => p is SpotDetailFree && c is SpotDetailFree && p.startStatus != c.startStatus,
        builder: (context, state) {
          final isLoading = state is SpotDetailFree && state.startStatus.isLoading;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x4),
            child: FilledButton(
              onPressed: isLoading ? null : _onStartSession,
              style: FilledButton.styleFrom(
                backgroundColor: context.appColors.success,
                foregroundColor: context.appColors.onSuccess,
                minimumSize: const Size(double.infinity, AppSpacing.x16),
                shape: const RoundedRectangleBorder(
                  borderRadius: AppRadius.buttonBorderRadius,
                ),
              ),
              child: isLoading ? const AppActivityIndicator() : Text(context.l10n.spotDetailStart),
            ),
          );
        },
      ),
    );
  }

  Future<void> _onStartSession() async {
    final customerName = await StartSessionSheet.show(context);
    if (customerName == null || !mounted) return;

    await widget.spotCubit.startSession(customerName.trim().isEmpty ? null : customerName.trim());
  }

  Future<void> _onEdit() async {
    final updated = await context.push<SpotModel>(
      AppRoutes.spotForm,
      extra: SpotFormExtra(
        venueId: _spot.venueId,
        spot: _spot,
      ),
    );
    if (!mounted || updated == null) return;
    setState(() => _spot = updated);
    widget.spotCubit.updateSpot(updated);
  }

  Future<void> _onDelete() async {
    await AppDestructiveSheet.show(
      context,
      icon: Icons.delete_outline_rounded,
      title: context.l10n.deleteSpotButton,
      subtitle: context.l10n.deleteSpotSubtitle,
      confirmLabel: context.l10n.deleteSpotButton,
      onConfirm: widget.spotCubit.deleteSpot,
    );
    if (!mounted) return;
    final deleteStatus = switch (widget.spotCubit.state) {
      SpotDetailFree(:final deleteStatus) => deleteStatus,
      SpotDetailOccupied(:final deleteStatus) => deleteStatus,
    };
    if (deleteStatus.isSuccess) {
      unawaited(context.read<HomeCubit>().load());
      await WidgetsBinding.instance.endOfFrame;
      if (!mounted) return;
      context.pop();
    } else if (deleteStatus is RequestFailure<bool>) {
      context.handleError(deleteStatus.exception);
    }
  }
}
