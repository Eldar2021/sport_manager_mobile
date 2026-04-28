import 'package:facility/facility.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sport_manager_mobile/core/core.dart';

class VenuesCubit extends Cubit<DataState<List<VenueModel>>> {
  VenuesCubit(this._repository) : super(const DataInitial());

  final FacilityRepository _repository;

  Future<void> load() async {
    if (state is DataLoading) return;
    try {
      emit(const DataLoading());
      final venues = await _repository.getVenues();
      emit(DataSuccess(venues));
    } on Object catch (e) {
      emit(DataFailure(e));
    }
  }
}
