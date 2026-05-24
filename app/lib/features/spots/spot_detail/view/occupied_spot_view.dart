import 'package:core/core.dart';
import 'package:facility/facility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:sport_manager_mobile/core/core.dart';
import 'package:sport_manager_mobile/features/home/home.dart';
import 'package:sport_manager_mobile/features/spots/spots.dart';
import 'package:sport_manager_mobile/features/venues/venues.dart';
import 'package:sport_manager_mobile/l10n/l10n.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

class OccupiedSpotView extends StatefulWidget {
  const OccupiedSpotView({
    required this.spotCubit,
    required this.spot,
    required this.session,
    super.key,
  });

  final SpotDetailCubit spotCubit;
  final SpotModel spot;
  final SessionModel session;

  @override
  State<OccupiedSpotView> createState() => _OccupiedSpotViewState();
}

class _OccupiedSpotViewState extends State<OccupiedSpotView> {
  late final SessionActiveCubit _sessionCubit;
  late VenueType _venueType;

  @override
  void initState() {
    super.initState();
    _sessionCubit = SessionActiveCubit(
      session: widget.session,
      repository: GetIt.I<SessionRepository>(),
    );
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
  void dispose() {
    _sessionCubit.close();
    super.dispose();
  }

  void _showPaymentSheet() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) => BlocProvider.value(
        value: _sessionCubit,
        child: PaymentSummarySheet(widget.spot, venueType: _venueType),
      ),
    );
  }

  void _showCancelConfirm() {
    AppDestructiveSheet.show(
      context,
      icon: Icons.cancel_outlined,
      title: context.l10n.spotDetailMistakeLaunchTitle,
      subtitle: context.l10n.spotDetailMistakeLaunchSubtitle,
      confirmLabel: context.l10n.spotDetailMistakeLaunchConfirm,
      onConfirm: _sessionCubit.cancelSession,
    );
  }

  void _showAddProductSheet() {
    AddProductSheet.show(
      context,
      currency: widget.spot.currency.localizedName(context.l10n),
      sessionCubit: _sessionCubit,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          widget.spot.name ?? context.l10n.homeSpotTitle(_venueType.spotLabel(context), widget.spot.number),
        ),
      ),
      body: BlocProvider.value(
        value: _sessionCubit,
        child: MultiBlocListener(
          listeners: [
            BlocListener<SessionActiveCubit, SessionActiveState>(
              bloc: _sessionCubit,
              listenWhen: (p, c) => p.stopStatus != c.stopStatus,
              listener: (context, state) {
                if (state.stopStatus.isSuccess) {
                  widget.spotCubit.onSessionEnded();
                  context.read<HomeCubit>().load();
                }
              },
            ),
            BlocListener<SessionActiveCubit, SessionActiveState>(
              bloc: _sessionCubit,
              listenWhen: (p, c) => p.cancelStatus != c.cancelStatus,
              listener: (context, state) {
                if (state.cancelStatus.isSuccess) {
                  widget.spotCubit.onSessionEnded();
                  context.read<HomeCubit>().load();
                } else if (state.cancelStatus.isFailure) {
                  context.handleError((state.cancelStatus as RequestFailure<SessionModel>).exception);
                }
              },
            ),
            BlocListener<SessionActiveCubit, SessionActiveState>(
              bloc: _sessionCubit,
              listenWhen: (p, c) => p.pauseStatus != c.pauseStatus,
              listener: (context, state) {
                if (state.pauseStatus.isSuccess) {
                  context.read<HomeCubit>().load();
                } else if (state.pauseStatus.isFailure) {
                  context.handleError((state.pauseStatus as RequestFailure<SessionModel>).exception);
                }
              },
            ),
            BlocListener<SessionActiveCubit, SessionActiveState>(
              bloc: _sessionCubit,
              listenWhen: (p, c) => p.resumeStatus != c.resumeStatus,
              listener: (context, state) {
                if (state.resumeStatus.isSuccess) {
                  context.read<HomeCubit>().load();
                } else if (state.resumeStatus.isFailure) {
                  context.handleError((state.resumeStatus as RequestFailure<SessionModel>).exception);
                }
              },
            ),
            BlocListener<SessionActiveCubit, SessionActiveState>(
              bloc: _sessionCubit,
              listenWhen: (p, c) => p.removeProductStatus != c.removeProductStatus,
              listener: (context, state) {
                if (state.removeProductStatus.isFailure) {
                  context.handleError((state.removeProductStatus as RequestFailure<void>).exception);
                }
              },
            ),
            BlocListener<SessionActiveCubit, SessionActiveState>(
              bloc: _sessionCubit,
              listenWhen: (p, c) => p.addProductStatus != c.addProductStatus,
              listener: (context, state) {
                if (state.addProductStatus.isFailure) {
                  context.handleError((state.addProductStatus as RequestFailure<SessionModel>).exception);
                }
              },
            ),
          ],
          child: OccupiedSpotBody(
            currency: widget.spot.currency.localizedName(context.l10n),
            onMistakeLaunch: _showCancelConfirm,
            onAddProduct: _showAddProductSheet,
          ),
        ),
      ),
      floatingActionButtonLocation: kAppButtonFabLocation,
      floatingActionButton: OccupiedSpotFooter(
        sessionCubit: _sessionCubit,
        onStopPressed: _showPaymentSheet,
      ),
    );
  }
}
