import 'package:auth/auth.dart';

abstract interface class AuthRemoteSource {
  Future<AuthResultModel> login({
    required String username,
    required String password,
  });

  Future<AuthResultModel> register(RegisterParam param);

  Future<AuthTokensModel> refresh(String refreshToken);

  Future<void> logout();

  Future<void> deleteAccount();

  Future<void> forgotPassword(String email);

  Future<AuthTokensModel> updatePassword({
    required String login,
    required String newPassword,
  });

  Future<InviteCodeModel> getInviteCode();

  Future<ProfileModel> getProfile();
}
