import 'package:auth/auth.dart';

abstract interface class AuthRemoteSource {
  Future<AuthResultModel> login({
    required String username,
    required String password,
  });

  Future<void> forgotPassword(String email);

  Future<AuthResultModel> registerOwner(RegisterOwnerBody body);

  Future<AuthResultModel> registerManager(RegisterManagerBody body);

  Future<void> logout();
}
