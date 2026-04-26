import 'package:auth/auth.dart';

abstract interface class AuthLocalSource {
  Future<void> init();

  Future<void> saveTokens(AuthTokensModel tokens);

  Future<AuthTokensModel?> getTokens();

  String? getAccessTokenSync();

  String? getRefreshTokenSync();

  Future<void> saveUser(UserModel user);

  UserModel? getCachedUser();

  Future<void> clearAll();
}
