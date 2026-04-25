import 'package:auth/auth.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'auth_state.dart';

final class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this._repository) : super(const AuthInitial());

  final AuthRepository _repository;

  Future<void> checkAuthStatus() async {
    emit(const AuthLoading());
    try {
      final tokens = await _repository.getTokens();
      if (tokens == null) {
        emit(const AuthUnauthenticated());
        return;
      }
      final user = _repository.getCachedUser();
      if (user != null) {
        emit(AuthAuthenticated(user: user));
      } else {
        emit(const AuthUnauthenticated());
      }
    } on Object catch (_) {
      emit(const AuthUnauthenticated());
    }
  }

  Future<void> login(String username, String password) async {
    emit(const AuthLoading());
    try {
      final result = await _repository.login(
        username: username.trim(),
        password: password,
      );
      emit(AuthAuthenticated(user: result.user));
    } on Object catch (e) {
      emit(AuthError(exception: e));
    }
  }

  void setAuthenticated(UserModel user) => emit(AuthAuthenticated(user: user));

  Future<void> logout() async {
    emit(const AuthLoading());
    try {
      await _repository.logout();
    } finally {
      emit(const AuthUnauthenticated());
    }
  }
}
