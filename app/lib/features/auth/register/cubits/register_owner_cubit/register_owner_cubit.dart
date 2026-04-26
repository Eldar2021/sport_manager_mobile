import 'dart:developer';

import 'package:auth/auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sport_manager_mobile/core/core.dart';

class RegisterOwnerCubit extends Cubit<DataState<AuthResultModel>> {
  RegisterOwnerCubit(this._repository) : super(const DataInitial());

  final AuthRepository _repository;

  Future<void> registerOwner(RegisterOwnerBody body) async {
    if (state.isLoading) return;
    emit(const DataLoading());
    try {
      final result = await _repository.registerOwner(body);
      emit(DataSuccess(result));
    } on Object catch (e) {
      log('Failed to register owner', error: e);
      emit(DataFailure(e));
    }
  }
}
