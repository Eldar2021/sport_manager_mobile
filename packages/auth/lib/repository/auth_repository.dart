import 'dart:developer';

import 'package:auth/auth.dart';
import 'package:meta/meta.dart';

@immutable
final class AuthRepository {
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

  Future<AuthTokensModel?> getTokens() => _local.getTokens();

  UserModel? getCachedUser() => _local.getCachedUser();

  Future<void> logout() async {
    try {
      await _remote.logout();
    } on Object catch (e) {
      log('remote logout failed (ignored): $e');
    }
    await _local.clearAll();
  }

  Future<void> deleteAccount() async {
    await _remote.deleteAccount();
    await _local.clearAll();
  }

  Future<InviteCodeModel> getInviteCode() => _remote.getInviteCode();

  Future<ProfileModel> getProfile() => _remote.getProfile();
}
