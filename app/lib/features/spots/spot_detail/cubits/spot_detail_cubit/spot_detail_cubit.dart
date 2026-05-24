import 'package:core/core.dart';
import 'package:equatable/equatable.dart';
import 'package:facility/facility.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'spot_detail_state.dart';

class SpotDetailCubit extends Cubit<SpotDetailState> {
  SpotDetailCubit({
    required SpotModel spot,
    required SessionRepository sessionRepository,
    required FacilityRepository facilityRepository,
  }) : _sessionRepo = sessionRepository,
       _facilityRepo = facilityRepository,
       super(
         spot.session != null ? SpotDetailOccupied(spot: spot, session: spot.session!) : SpotDetailFree(spot: spot),
       );

  final SessionRepository _sessionRepo;
  final FacilityRepository _facilityRepo;

  Future<void> startSession(String? customerName) async {
    if (state is! SpotDetailFree) return;
    final s = state as SpotDetailFree;
    emit(s.copyWith(startStatus: const RequestLoading()));
    try {
      final session = await _sessionRepo.startSession(s.spot.id, customerName);
      emit(SpotDetailOccupied(spot: s.spot, session: session));
    } on Object catch (e) {
      emit(s.copyWith(startStatus: RequestFailure(e)));
    }
  }

  void updateSpot(SpotModel updated) {
    emit(
      switch (state) {
        final SpotDetailFree s => s.copyWith(spot: updated),
        final SpotDetailOccupied s => s.copyWith(spot: updated),
      },
    );
  }

  void updateSession(SessionModel session) {
    if (state is! SpotDetailOccupied) return;
    emit((state as SpotDetailOccupied).copyWith(session: session));
  }

  void onSessionEnded() {
    if (state is! SpotDetailOccupied) return;
    final spot = (state as SpotDetailOccupied).spot;
    emit(SpotDetailFree(spot: spot));
  }

  Future<void> deleteSpot() async {
    final spotId = switch (state) {
      SpotDetailFree(:final spot) => spot.id,
      SpotDetailOccupied(:final spot) => spot.id,
    };
    _emitDeleteStatus(const RequestLoading());
    try {
      await _facilityRepo.deleteSpot(spotId);
      _emitDeleteStatus(const RequestSuccess(true));
    } on Object catch (e) {
      _emitDeleteStatus(RequestFailure(e));
    }
  }

  void _emitDeleteStatus(RequestStatus<bool> status) {
    emit(
      switch (state) {
        final SpotDetailFree s => s.copyWith(deleteStatus: status),
        final SpotDetailOccupied s => s.copyWith(deleteStatus: status),
      },
    );
  }
}
