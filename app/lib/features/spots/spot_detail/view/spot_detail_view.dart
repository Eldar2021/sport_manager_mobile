import 'package:facility/facility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:sport_manager_mobile/features/spots/spots.dart';

class SpotDetailView extends StatefulWidget {
  const SpotDetailView(this.spot, {super.key});

  final SpotModel spot;

  @override
  State<SpotDetailView> createState() => _SpotDetailViewState();
}

class _SpotDetailViewState extends State<SpotDetailView> {
  late final SpotDetailCubit _spotCubit;

  @override
  void initState() {
    super.initState();
    _spotCubit = SpotDetailCubit(
      spot: widget.spot,
      sessionRepository: GetIt.I<SessionRepository>(),
      facilityRepository: GetIt.I<FacilityRepository>(),
    );
  }

  @override
  void dispose() {
    _spotCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SpotDetailCubit, SpotDetailState>(
      bloc: _spotCubit,
      buildWhen: (prev, curr) => prev.runtimeType != curr.runtimeType,
      builder: (context, state) => switch (state) {
        SpotDetailFree() => FreeSpotView(
          spotCubit: _spotCubit,
          spot: widget.spot,
        ),
        SpotDetailOccupied(:final spot, :final session) => OccupiedSpotView(
          spotCubit: _spotCubit,
          spot: spot,
          session: session,
        ),
      },
    );
  }
}
