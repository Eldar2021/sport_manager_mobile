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
    final result = await _remote.login(username: username, password: password);
    await _local.saveTokens(result.tokens);
    await _local.saveUser(result.user);
    return result;
  }

  Future<AuthResultModel> registerOwner(RegisterOwnerBody body) async {
    final result = await _remote.registerOwner(body);
    await _local.saveTokens(result.tokens);
    await _local.saveUser(result.user);
    return result;
  }

  Future<AuthResultModel> registerManager(RegisterManagerBody body) async {
    final result = await _remote.registerManager(body);
    await _local.saveTokens(result.tokens);
    await _local.saveUser(result.user);
    return result;
  }

  Future<void> forgotPassword(String email) {
    return _remote.forgotPassword(email);
  }

  Future<AuthTokensModel?> getTokens() => _local.getTokens();

  String? getRefreshTokenSync() => _local.getRefreshTokenSync();

  String? getAccessTokenSync() => _local.getAccessTokenSync();

  UserModel? getCachedUser() => _local.getCachedUser();

  void cacheRefreshedTokens(String accessToken, String refreshToken) {
    _local.saveTokens(AuthTokensModel(accessToken: accessToken, refreshToken: refreshToken));
  }

  Future<void> logout() async {
    try {
      await _remote.logout();
    } finally {
      await _local.clearAll();
    }
  }

  Future<InviteCodeModel> getInviteCode() {
    return _remote.getInviteCode();
  }
}
