import 'dart:developer';

import 'package:auth/auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sport_manager_mobile/core/core.dart';

class ForgotPasswordCubit extends Cubit<DataState<void>> {
  ForgotPasswordCubit(this._repository) : super(const DataInitial());

  final AuthRepository _repository;

  Future<void> send(String email) async {
    emit(const DataLoading<void>());
    try {
      await _repository.forgotPassword(email);
      emit(const DataSuccess<void>(null));
    } on Object catch (e) {
      log('forgot password error', error: e);
      emit(DataFailure(e));
    }
  }
}
