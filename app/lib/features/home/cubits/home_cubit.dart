import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:facility/facility.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit(this.repository) : super(const HomeLoading());

  final FacilityRepository repository;
  bool _loading = false;

  Future<void> load() {
    return _fetch(repository.getSelected);
  }

  Future<void> selectVenue(String venueId) {
    return _fetch(() => repository.updateSelected(venueId));
  }

  Future<void> _fetch(Future<SelectedVenueModel> Function() action) async {
    if (_loading) return;
    _loading = true;
    try {
      emit(const HomeLoading());
      final response = await action();
      if (response.tables.isNotEmpty) {
        emit(
          HomeLoaded(
            venue: response.venue,
            tables: response.tables,
          ),
        );
      } else {
        emit(HomeNoTables(response.venue));
      }
    } on VenueException catch (e) {
      if (e.error == VenueErrorCode.notFound) {
        emit(const HomeNoVenue());
      } else {
        emit(HomeFailure(e));
      }
    } on Object catch (e) {
      emit(HomeFailure(e));
    } finally {
      _loading = false;
    }
  }
}
