import 'package:core/core.dart';
import 'package:equatable/equatable.dart';
import 'package:facility/facility.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'venue_form_state.dart';

class VenueFormCubit extends Cubit<VenueFormState> {
  VenueFormCubit({
    required FacilityRepository repository,
    VenueModel? venue,
  }) : _repository = repository,
       _venueId = venue?.id,
       super(VenueFormState(selectedType: venue?.type));

  final FacilityRepository _repository;
  final String? _venueId;

  bool get isEdit => _venueId != null;

  void selectType(VenueType type) {
    emit(state.copyWith(selectedType: type));
  }

  Future<void> submit(VenueFormParam param) async {
    if (state.isLoading) return;
    emit(state.copyWith(reqStatus: const RequestLoading()));

    try {
      final result = _venueId != null
          ? await _repository.updateVenue(_venueId, param)
          : await _repository.createVenue(param);

      emit(state.copyWith(reqStatus: RequestSuccess(result)));
    } on Object catch (e) {
      emit(state.copyWith(reqStatus: RequestFailure(e)));
    }
  }

  Future<void> deleteVenue() async {
    if (_venueId == null) return;
    emit(state.copyWith(deleteStatus: const RequestLoading()));
    try {
      await _repository.deleteVenue(_venueId);
      emit(state.copyWith(deleteStatus: const RequestSuccess(true)));
    } on Object catch (e) {
      emit(state.copyWith(deleteStatus: RequestFailure(e)));
    }
  }
}
