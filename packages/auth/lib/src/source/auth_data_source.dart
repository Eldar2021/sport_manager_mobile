import 'package:auth/auth.dart';

abstract interface class AuthDataSource {
  Future<AuthResultModel> login({
    required String username,
    required String password,
  });

  Future<AuthResultModel> registerOwner(RegisterOwnerBody body);

  Future<AuthResultModel> registerManager(RegisterManagerBody body);
}
