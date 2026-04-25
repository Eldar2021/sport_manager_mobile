import 'package:auth/auth.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sport_manager_mobile/core/core.dart';

part 'forgot_password_state.dart';

final class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  ForgotPasswordCubit(this._repository) : super(const ForgotPasswordState());

  final AuthRepository _repository;

  void emailChanged(String email) {
    emit(state.copyWith(email: email));
  }

  Future<void> send() async {
    if (!state.canSubmit) return;

    emit(state.copyWith(status: const DataLoading<void>()));
    try {
      await _repository.forgotPassword(state.email.trim());
      emit(state.copyWith(status: const DataSuccess<void>(null)));
    } on Object catch (e) {
      emit(state.copyWith(status: DataFailure(e)));
    }
  }
}
