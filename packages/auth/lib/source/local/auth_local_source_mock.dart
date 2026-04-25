import 'package:auth/auth.dart';

final class AuthLocalSourceMock implements AuthLocalSource {
  AuthTokensModel? _tokens;
  UserModel? _user;

  @override
  Future<void> saveTokens(AuthTokensModel tokens) async => _tokens = tokens;

  @override
  Future<AuthTokensModel?> getTokens() async => _tokens;

  @override
  String? getAccessTokenSync() => _tokens?.accessToken;

  @override
  String? getRefreshTokenSync() => _tokens?.refreshToken;

  @override
  Future<void> saveUser(UserModel user) async => _user = user;

  @override
  UserModel? getCachedUser() => _user;

  @override
  Future<void> clearAll() async {
    _tokens = null;
    _user = null;
  }
}
