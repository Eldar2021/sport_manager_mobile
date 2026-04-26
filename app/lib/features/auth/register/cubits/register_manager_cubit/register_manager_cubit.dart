import 'dart:developer';

import 'package:auth/auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sport_manager_mobile/core/core.dart';

class RegisterManagerCubit extends Cubit<DataState<AuthResultModel>> {
  RegisterManagerCubit(this._repository) : super(const DataInitial());

  final AuthRepository _repository;

  Future<void> registerManager(RegisterManagerBody body) async {
    if (state.isLoading) return;
    emit(const DataLoading());
    try {
      final result = await _repository.registerManager(body);
      emit(DataSuccess(result));
    } on Object catch (e) {
      log('Failed to register manager', error: e);
      emit(DataFailure(e));
    }
  }
}
