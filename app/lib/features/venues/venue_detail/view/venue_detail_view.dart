import 'dart:async';
import 'package:core/core.dart';
import 'package:facility/facility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:sport_manager_mobile/app/app.dart';
import 'package:sport_manager_mobile/core/core.dart';
import 'package:sport_manager_mobile/features/auth/auth.dart';
import 'package:sport_manager_mobile/features/home/home.dart';
import 'package:sport_manager_mobile/features/profile/profile.dart';
import 'package:sport_manager_mobile/features/spots/spots.dart';
import 'package:sport_manager_mobile/features/venues/venues.dart';
import 'package:sport_manager_mobile/l10n/l10n.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

class VenueDetailView extends StatefulWidget {
  const VenueDetailView({required this.venue, super.key});

  final VenueModel venue;

  @override
  State<VenueDetailView> createState() => _VenueDetailViewState();
}

class _VenueDetailViewState extends State<VenueDetailView> {
  late final VenueDetailCubit _cubit;
  late VenueModel _venue;

  @override
  void initState() {
    super.initState();
    _venue = widget.venue;
    _cubit = VenueDetailCubit(
      repository: GetIt.I<FacilityRepository>(),
      venueId: _venue.id,
    );
    _cubit.load();
  }

  @override
  Widget build(BuildContext context) {
    final isOwner = context.select<AuthCubit, bool>((c) => c.state.isOwner);
    final spotLabelUpper = _venue.type.spotLabelPlural(context).toUpperCase();
    return AppButtonScope(
      child: Scaffold(
        appBar: AppBar(
          title: Text(_venue.name),
          actions: [
            if (isOwner) ...[
              AppEditDeleteMenu(
                onEdit: _onEdit,
                onDelete: _onDelete,
              ),
              const SizedBox(width: AppSpacing.x2),
            ],
          ],
        ),
        body: RefreshIndicator.adaptive(
          onRefresh: _cubit.load,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.x4,
              AppSpacing.x4,
              AppSpacing.x4,
              kAppButtonFabClearance,
            ),
            children: [
              VenueDetailHeaderCard(
                venue: _venue,
                spotCount: _venue.spotCount,
              ),
              const SizedBox(height: AppSpacing.x4),
              BlocBuilder<VenueDetailCubit, VenueDetailState>(
                bloc: _cubit,
                buildWhen: (prev, next) => prev.spots != next.spots,
                builder: (context, state) {
                  return switch (state.spots) {
                    RequestInitial<List<SpotModel>>() || RequestLoading<List<SpotModel>>() => VenueSpotsSection(
                      headerLabel: spotLabelUpper,
                      countSuffix: null,
                      child: const VenueDetailSkeleton(),
                    ),
                    RequestFailure<List<SpotModel>>(:final exception) => VenueSpotsSection(
                      headerLabel: spotLabelUpper,
                      countSuffix: null,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: AppSpacing.x6),
                        child: ErrorBodyWidget(
                          exception,
                          onRetryPressed: _cubit.load,
                        ),
                      ),
                    ),
                    RequestSuccess<List<SpotModel>>(:final data) => VenueSpotsSection(
                      headerLabel: spotLabelUpper,
                      countSuffix: context.l10n.venueSpotsCountSuffix(data.length),
                      child: data.isEmpty
                          ? Padding(
                              padding: const EdgeInsets.symmetric(vertical: AppSpacing.x10),
                              child: SpotsEmptyView(venueType: _venue.type),
                            )
                          : SpotsList(
                              spots: data,
                              venueId: _venue.id,
                              venueType: _venue.type,
                              isOwner: isOwner,
                              onSpotUpdated: _cubit.load,
                            ),
                    ),
                  };
                },
              ),
            ],
          ),
        ),
        floatingActionButtonLocation: kAppButtonFabLocation,
        floatingActionButton: isOwner
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x4),
                child: AppButton(
                  leading: const Icon(Icons.add_rounded),
                  onPressed: _onAddSpot,
                  child: Text(context.l10n.homeAddSpot(_venue.type.spotLabel(context))),
                ),
              )
            : null,
      ),
    );
  }

  Future<void> _onAddSpot() async {
    final added = await context.push(
      AppRoutes.spotForm,
      extra: SpotFormExtra(venueId: _venue.id),
    );
    if (added != null) unawaited(_cubit.load());
  }

  Future<void> _onEdit() async {
    final updated = await context.push<VenueModel>(
      AppRoutes.venueForm,
      extra: _venue,
    );
    if (mounted && updated != null) {
      setState(() => _venue = updated);
      unawaited(context.read<HomeCubit>().load());
      unawaited(context.read<ProfileCubit>().fetchProfile());
    }
  }

  Future<void> _onDelete() async {
    await AppDestructiveSheet.show(
      context,
      icon: Icons.delete_outline_rounded,
      title: context.l10n.deleteVenueButton,
      subtitle: context.l10n.deleteVenueSubtitle,
      confirmLabel: context.l10n.deleteVenueButton,
      onConfirm: _cubit.deleteVenue,
    );
    if (!mounted) return;
    final status = _cubit.state.deleteStatus;
    if (status is RequestSuccess<bool>) {
      unawaited(context.read<HomeCubit>().load());
      unawaited(context.read<ProfileCubit>().fetchProfile());
      await WidgetsBinding.instance.endOfFrame;
      if (!mounted) return;
      context.pop(true);
    } else if (status is RequestFailure<bool>) {
      context.handleError(status.exception);
    }
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }
}
