import 'package:auth/auth.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sport_manager_mobile/core/core.dart';

part 'login_state.dart';

final class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this._repository) : super(const LoginState());

  final AuthRepository _repository;

  void usernameChanged(String value) => emit(
    state.copyWith(
      username: value,
      status: const DataInitial(),
    ),
  );

  void passwordChanged(String value) => emit(
    state.copyWith(
      password: value,
      status: const DataInitial(),
    ),
  );

  Future<void> login() async {
    if (!state.canSubmit) return;

    try {
      emit(state.copyWith(status: const DataLoading()));

      await _repository.login(
        username: state.username.trim(),
        password: state.password,
      );

      emit(state.copyWith(status: const DataSuccess(null)));
    } on Object catch (e) {
      emit(state.copyWith(status: DataFailure(e)));
    }
  }
}
