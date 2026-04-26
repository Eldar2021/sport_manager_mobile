import 'dart:developer';

import 'package:auth/auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sport_manager_mobile/core/core.dart';

class RegisterCubit extends Cubit<DataState<AuthResultModel>> {
  RegisterCubit(this._repository) : super(const DataInitial());

  final AuthRepository _repository;

  Future<void> register(RegisterParam body) async {
    if (state.isLoading) return;
    emit(const DataLoading());
    try {
      final result = await _repository.register(body);
      emit(DataSuccess(result));
    } on Object catch (e) {
      log('Failed to register', error: e);
      emit(DataFailure(e));
    }
  }
}
