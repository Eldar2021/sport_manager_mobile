import 'dart:developer';

import 'package:auth/auth.dart';

class AuthRepository {
  const AuthRepository({
    required AuthRemoteSource remote,
    required AuthLocalSource local,
  }) : _remote = remote,
       _local = local;

  final AuthRemoteSource _remote;
  final AuthLocalSource _local;

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

  Future<AuthResultModel> register(RegisterParam body) async {
    final result = await _remote.register(body);
    await Future.wait([
      _local.saveTokens(result.tokens),
      _local.saveUser(result.user),
    ]);
    return result;
  }

  Future<void> forgotPassword(String email) {
    return _remote.forgotPassword(email);
  }

  Future<AuthTokensModel?> getTokens() {
    return _local.getTokens();
  }

  String? getRefreshTokenSync() {
    return _local.getRefreshTokenSync();
  }

  String? getAccessTokenSync() {
    return _local.getAccessTokenSync();
  }

  UserModel? getCachedUser() {
    return _local.getCachedUser();
  }

  void cacheRefreshedTokens(String accessToken, String refreshToken) {
    _local.saveTokens(
      AuthTokensModel(
        accessToken: accessToken,
        refreshToken: refreshToken,
      ),
    );
  }

  Future<void> logout() async {
    try {
      await Future.wait([
        _remote.logout(),
        _local.clearAll(),
      ]);
    } on Object catch (e) {
      log('logout error: $e');
      return;
    }
  }

  Future<InviteCodeModel> getInviteCode() {
    return _remote.getInviteCode();
  }
}
