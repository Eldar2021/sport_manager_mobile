abstract interface class AuthLocalSource {
  Future<void> saveTokens(String token);

  String? getToken();

  Future<void> clearTokens();
}
