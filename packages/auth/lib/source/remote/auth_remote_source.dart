import 'package:auth/auth.dart';

abstract interface class AuthRemoteSource {
  Future<AuthResultModel> login({
    required String username,
    required String password,
  });

  Future<AuthResultModel> registerOwner(RegisterOwnerBody body);

  Future<AuthResultModel> registerManager(RegisterManagerBody body);

  Future<AuthTokensModel> refresh(String refreshToken);

  Future<void> logout();

  Future<void> forgotPassword(String email);

  Future<InviteCodeModel> getInviteCode();
}
