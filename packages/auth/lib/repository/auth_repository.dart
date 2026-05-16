import 'dart:async';
import 'dart:developer';

import 'package:auth/auth.dart';

final class AuthRepository {
  AuthRepository({
    required AuthRemoteSource remote,
    required AuthLocalSource local,
  }) : _remote = remote,
       _local = local;

  final AuthRemoteSource _remote;
  final AuthLocalSource _local;

  final _forceLogoutController = StreamController<void>.broadcast();

  /// Emits when the session is terminated outside the UI (e.g. the
  /// auth interceptor exhausts the refresh-token flow and calls
  /// [logout]). `AuthCubit` listens to this so the router can redirect
  /// to the unauthenticated stack.
  Stream<void> get onForceLogout => _forceLogoutController.stream;

  Future<AuthResultModel> login({
    required String username,
    required String password,
  }) async {
    final result = await _remote.login(
      username: username,
      password: password,
    );
    await Future.wait([
      _local.saveTokens(result.tokens),
      _local.saveUser(result.user),
    ]);
    return result;
  }

  Future<AuthResultModel> register(RegisterParam param) async {
    final result = await _remote.register(param);
    await Future.wait([
      _local.saveTokens(result.tokens),
      _local.saveUser(result.user),
    ]);
    return result;
  }

  Future<void> forgotPassword(String email) {
    return _remote.forgotPassword(email);
  }

  Future<void> updatePassword({
    required String login,
    required String newPassword,
  }) async {
    final tokens = await _remote.updatePassword(
      login: login,
      newPassword: newPassword,
    );
    await _local.saveTokens(tokens);
  }

  Future<AuthTokensModel?> getTokens() {
    return _local.getTokens();
  }

  UserModel? getCachedUser() {
    return _local.getCachedUser();
  }

  Future<void> logout() async {
    await _local.clearAll();
    if (!_forceLogoutController.isClosed) _forceLogoutController.add(null);
    try {
      unawaited(_remote.logout());
    } on Object catch (e) {
      log('remote logout failed (ignored): $e');
    }
  }

  Future<void> deleteAccount() async {
    await _local.clearAll();
    try {
      unawaited(_remote.deleteAccount());
    } on Object catch (e) {
      log('remote delete account failed (ignored): $e');
    }
  }

  Future<InviteCodeModel> getInviteCode() {
    return _remote.getInviteCode();
  }

  Future<ProfileModel> getProfile() {
    return _remote.getProfile();
  }
}
