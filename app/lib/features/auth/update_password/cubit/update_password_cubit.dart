import 'dart:developer';

import 'package:auth/auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sport_manager_mobile/core/core.dart';

class UpdatePasswordCubit extends Cubit<DataState<void>> {
  UpdatePasswordCubit(this._repository) : super(const DataInitial());

  final AuthRepository _repository;

  Future<void> updatePassword({
    required String login,
    required String newPassword,
  }) async {
    emit(const DataLoading<void>());
    try {
      await _repository.updatePassword(
        login: login,
        newPassword: newPassword,
      );
      emit(const DataSuccess<void>(null));
    } on Object catch (e) {
      log('update password error', error: e);
      emit(DataFailure(e));
    }
  }
}
