import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:facility/facility.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit(this.repository) : super(const HomeLoading());

  final FacilityRepository repository;

  Future<void> load() {
    return _fetch(repository.getSelected);
  }

  Future<void> selectVenue(String venueId) {
    return _fetch(() => repository.updateSelected(venueId));
  }

  Future<void> _fetch(Future<SelectedVenueModel> Function() action) async {
    try {
      emit(const HomeLoading());
      final response = await action();
      if (response.spots.isNotEmpty) {
        emit(
          HomeLoaded(
            venue: response.venue,
            spots: response.spots,
          ),
        );
      } else {
        emit(HomeNoSpots(response.venue));
      }
    } on FacilityExc catch (e) {
      emit(switch (e.error) {
        FacilityErrorCode.venueNotFound => const HomeNoVenue(),
        _ => HomeFailure(e),
      });
    } on Object catch (e) {
      emit(HomeFailure(e));
    }
  }
}
