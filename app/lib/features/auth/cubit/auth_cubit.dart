import 'dart:developer';

import 'package:auth/auth.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this._repository) : super(const AuthInitial());

  final AuthRepository _repository;

  Future<void> checkAuthStatus() async {
    try {
      final tokens = await _repository.getTokens();

      if (tokens != null && tokens.accessToken.isNotEmpty) {
        final cachedUser = _repository.getCachedUser();
        if (cachedUser != null) {
          emit(AuthAuthenticated(user: cachedUser));
          return;
        }
      }

      emit(const AuthUnauthenticated());
    } on Object catch (_) {
      emit(const AuthUnauthenticated());
    }
  }

  void setAuthenticated(UserModel user) {
    emit(AuthAuthenticated(user: user));
  }

  Future<void> logout() async {
    emit(const AuthLoading());
    try {
      await _repository.logout();
      emit(const AuthUnauthenticated());
    } on Object catch (e) {
      log('logout error', error: e);
      emit(const AuthUnauthenticated());
    }
  }
}
