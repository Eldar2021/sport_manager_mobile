import 'dart:developer';

import 'package:core/core.dart';
import 'package:equatable/equatable.dart';
import 'package:facility/facility.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'venue_detail_state.dart';

class VenueDetailCubit extends Cubit<VenueDetailState> {
  VenueDetailCubit({
    required FacilityRepository repository,
    required String venueId,
  }) : _repository = repository,
       _venueId = venueId,
       super(const VenueDetailState());

  final FacilityRepository _repository;
  final String _venueId;

  Future<void> load() async {
    if (state.spots.isLoading) return;
    emit(state.copyWith(spots: const RequestLoading()));
    try {
      final spots = await _repository.getVenueSpots(_venueId);
      emit(state.copyWith(spots: RequestSuccess(spots)));
    } on Object catch (e) {
      log('Failed to load venue spots', error: e);
      emit(state.copyWith(spots: RequestFailure(e)));
    }
  }

  Future<void> deleteVenue() async {
    if (state.deleteStatus.isLoading) return;
    emit(state.copyWith(deleteStatus: const RequestLoading()));
    try {
      await _repository.deleteVenue(_venueId);
      emit(state.copyWith(deleteStatus: const RequestSuccess(true)));
    } on Object catch (e) {
      log('Failed to delete venue', error: e);
      emit(state.copyWith(deleteStatus: RequestFailure(e)));
    }
  }
}
