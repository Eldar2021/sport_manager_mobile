import 'dart:async';
import 'dart:developer';

import 'package:auth/auth.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this._repository) : super(const AuthInitial()) {
    _forceLogoutSub = _repository.onForceLogout.listen((_) {
      if (state is! AuthUnauthenticated) emit(const AuthUnauthenticated());
    });
  }

  final AuthRepository _repository;

  late final StreamSubscription<void> _forceLogoutSub;

  @override
  Future<void> close() {
    _forceLogoutSub.cancel();
    return super.close();
  }

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
    emit(const AuthLogoutInProgress());
    try {
      await _repository.logout();
      emit(const AuthUnauthenticated());
    } on Object catch (e) {
      log('logout error', error: e);
      emit(const AuthUnauthenticated());
    }
  }

  Future<void> deleteAccount() async {
    final previous = state;
    emit(const AuthLogoutInProgress());
    try {
      await _repository.deleteAccount();
      emit(const AuthUnauthenticated());
    } on Object catch (e) {
      log('delete account error', error: e);
      emit(previous);
      rethrow;
    }
  }
}
