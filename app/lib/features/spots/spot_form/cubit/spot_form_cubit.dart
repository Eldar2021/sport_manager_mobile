import 'package:core/core.dart';
import 'package:equatable/equatable.dart';
import 'package:facility/facility.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'spot_form_state.dart';

class SpotFormCubit extends Cubit<SpotFormState> {
  SpotFormCubit(
    this._repository,
    this._spotId,
  ) : super(const SpotFormState());

  final FacilityRepository _repository;
  final String? _spotId;

  Future<void> submit(SpotFormParam param) async {
    emit(state.copyWith(submitStatus: const RequestLoading()));
    try {
      final SpotModel result;
      if (_spotId != null) {
        result = await _repository.updateSpot(_spotId, param);
      } else {
        result = await _repository.createSpot(param);
      }
      emit(state.copyWith(submitStatus: RequestSuccess(result)));
    } on Object catch (e) {
      emit(state.copyWith(submitStatus: RequestFailure(e)));
    }
  }

  Future<void> deleteSpot() async {
    if (_spotId == null) return;
    emit(state.copyWith(deleteStatus: const RequestLoading()));
    try {
      await _repository.deleteSpot(_spotId);
      emit(state.copyWith(deleteStatus: const RequestSuccess(true)));
    } on Object catch (e) {
      emit(state.copyWith(deleteStatus: RequestFailure(e)));
    }
  }
}
