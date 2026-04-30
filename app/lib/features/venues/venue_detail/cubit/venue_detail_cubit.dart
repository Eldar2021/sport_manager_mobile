import 'dart:developer';

import 'package:facility/facility.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sport_manager_mobile/core/core.dart';

class VenueDetailCubit extends Cubit<DataState<List<TableModel>>> {
  VenueDetailCubit({
    required FacilityRepository repository,
    required String venueId,
  }) : _repository = repository,
       _venueId = venueId,
       super(const DataInitial());

  final FacilityRepository _repository;
  final String _venueId;

  Future<void> load() async {
    if (state is DataLoading) return;
    try {
      emit(const DataLoading());
      final tables = await _repository.getVenueTables(_venueId);
      emit(DataSuccess(tables));
    } on Object catch (e) {
      log('Failed to load venue tables', error: e);
      emit(DataFailure(e));
    }
  }
}
