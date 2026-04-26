import 'package:auth/auth.dart';

abstract interface class AuthRepository {
  Future<AuthResultModel> login({
    required String username,
    required String password,
  });

  Future<AuthResultModel> register(RegisterParam param);

  Future<void> forgotPassword(String email);

  Future<AuthTokensModel?> getTokens();

  UserModel? getCachedUser();

  Future<void> logout();

  Future<InviteCodeModel> getInviteCode();
}
