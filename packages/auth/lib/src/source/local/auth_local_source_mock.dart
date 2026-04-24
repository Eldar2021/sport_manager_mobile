import 'package:auth/auth.dart';

final class AuthLocalSourceMock implements AuthLocalSource {
  String? _token;

  @override
  Future<void> saveTokens(String token) async => _token = token;

  @override
  String? getToken() => _token;

  @override
  Future<void> clearTokens() async => _token = null;
}
