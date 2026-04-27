import 'package:core/core.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:venues/venues.dart';

part 'venue_form_state.dart';

class VenueFormCubit extends Cubit<VenueFormState> {
  VenueFormCubit(this._repository, {String? venueId})
    : _venueId = venueId,
      super(
        const VenueFormState(),
      );

  final VenueRepository _repository;
  final String? _venueId;

  Future<void> submit(String name, String number) async {
    if (state.isLoading) return;
    emit(state.copyWith(reqStatus: const RequestLoading()));
    try {
      final VenueModel result;
      if (_venueId != null) {
        result = await _repository.updateVenue(
          _venueId,
          UpdateVenueBody(
            name: name,
            number: number,
          ),
        );
      } else {
        result = await _repository.createVenue(
          CreateVenueBody(
            name: name,
            number: number,
          ),
        );
      }
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
