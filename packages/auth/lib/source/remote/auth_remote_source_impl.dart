import 'package:api_client/clients/api_client.dart';
import 'package:auth/auth.dart';
import 'package:meta/meta.dart';

@immutable
final class AuthRemoteSourceImpl implements AuthRemoteSource {
  const AuthRemoteSourceImpl({
    required ApiClient noAuthClient,
    required ApiClient bearerClient,
  }) : _noAuthClient = noAuthClient,
       _bearerClient = bearerClient;

  final ApiClient _bearerClient;
  final ApiClient _noAuthClient;

  @override
  Future<AuthResultModel> login({
    required String username,
    required String password,
  }) {
    return _noAuthClient.postType<AuthResultModel>(
      '/auth/login',
      fromJson: AuthResultModel.fromJson,
      data: {'username': username, 'password': password},
    );
  }

  @override
  Future<AuthResultModel> register(RegisterParam param) {
    return _noAuthClient.postType<AuthResultModel>(
      '/auth/register',
      fromJson: AuthResultModel.fromJson,
      data: param.toJson(),
    );
  }

  @override
  Future<AuthTokensModel> refresh(String refreshToken) {
    return _bearerClient.postType<AuthTokensModel>(
      '/auth/refresh',
      fromJson: AuthTokensModel.fromJson,
      data: {'refreshToken': refreshToken},
    );
  }

  @override
  Future<void> logout() {
    return _bearerClient.post('/auth/logout');
  }

  @override
  Future<void> deleteAccount() {
    return _bearerClient.delete('/auth/account');
  }

  @override
  Future<void> forgotPassword(String email) {
    return _noAuthClient.post(
      '/auth/forgot-password',
      data: {'email': email},
    );
  }

  @override
  Future<void> updatePassword({
    required String login,
    required String newPassword,
  }) {
    return _noAuthClient.put<void>(
      '/auth/update-password',
      data: {
        'login': login,
        'newPassword': newPassword,
      },
    );
  }

  @override
  Future<InviteCodeModel> getInviteCode() {
    return _bearerClient.postType<InviteCodeModel>(
      '/auth/invite-code',
      fromJson: InviteCodeModel.fromJson,
    );
  }

  @override
  Future<ProfileModel> getProfile() {
    return _bearerClient.postType<ProfileModel>(
      '/auth/profile',
      fromJson: ProfileModel.fromJson,
    );
  }
}
