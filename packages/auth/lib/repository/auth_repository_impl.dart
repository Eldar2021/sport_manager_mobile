import 'dart:developer';

import 'package:auth/auth.dart';
import 'package:meta/meta.dart';

@immutable
final class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl({
    required AuthRemoteSource remote,
    required AuthLocalSource local,
  }) : _remote = remote,
       _local = local;

  final AuthRemoteSource _remote;
  final AuthLocalSource _local;

  @override
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

  @override
  Future<AuthResultModel> register(RegisterParam param) async {
    final result = await _remote.register(param);
    await Future.wait([
      _local.saveTokens(result.tokens),
      _local.saveUser(result.user),
    ]);
    return result;
  }

  @override
  Future<void> forgotPassword(String email) {
    return _remote.forgotPassword(email);
  }

  @override
  Future<AuthTokensModel?> getTokens() => _local.getTokens();

  @override
  UserModel? getCachedUser() => _local.getCachedUser();

  @override
  Future<void> logout() async {
    await _local.clearAll();
    try {
      await _remote.logout();
    } on Object catch (e) {
      log('remote logout failed (ignored): $e');
    }
  }

  @override
  Future<InviteCodeModel> getInviteCode() => _remote.getInviteCode();
}
