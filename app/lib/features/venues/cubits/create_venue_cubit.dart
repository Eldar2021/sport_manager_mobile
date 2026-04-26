import 'package:core/core.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:venues/venues.dart';

part 'create_venue_state.dart';

class CreateVenueCubit extends Cubit<CreateVenueState> {
  CreateVenueCubit(this._repository) : super(const CreateVenueState());

  final VenueRepository _repository;

  void updateName(String value) {
    emit(state.copyWith(name: value));
  }

  void updateNumber(String value) {
    emit(state.copyWith(number: value));
  }

  Future<void> createVenue() async {
    if (!state.isValid) return;
    emit(state.copyWith(submitStatus: const RequestLoading()));
    try {
      final result = await _repository.createVenue(
        CreateVenueBody(name: state.name.trim(), number: state.number.trim()),
      );
      emit(state.copyWith(submitStatus: RequestSuccess(result)));
    } on Object catch (e) {
      emit(state.copyWith(submitStatus: RequestFailure(e)));
    }
  }
}
