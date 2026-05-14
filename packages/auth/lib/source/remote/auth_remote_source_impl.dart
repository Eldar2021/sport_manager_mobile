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

  static const String _authBaseUrl = '/api/v1/auth';

  @override
  Future<AuthResultModel> login({
    required String username,
    required String password,
  }) {
    return _noAuthClient.postType<AuthResultModel>(
      '$_authBaseUrl/login',
      fromJson: AuthResultModel.fromJson,
      data: {'username': username, 'password': password},
    );
  }

  @override
  Future<AuthResultModel> register(RegisterParam param) {
    return _noAuthClient.postType<AuthResultModel>(
      '$_authBaseUrl/register',
      fromJson: AuthResultModel.fromJson,
      data: param.toJson(),
    );
  }

  @override
  Future<AuthTokensModel> refresh(String refreshToken) {
    return _bearerClient.postType<AuthTokensModel>(
      '$_authBaseUrl/refresh',
      fromJson: AuthTokensModel.fromJson,
      data: {'refreshToken': refreshToken},
    );
  }

  @override
  Future<void> logout() {
    return _bearerClient.post<void>('$_authBaseUrl/logout');
  }

  @override
  Future<void> deleteAccount() {
    return _bearerClient.delete('$_authBaseUrl/account');
  }

  @override
  Future<void> forgotPassword(String email) {
    return _noAuthClient.post(
      '$_authBaseUrl/forgot-password',
      data: {'email': email},
    );
  }

  @override
  Future<void> updatePassword({
    required String login,
    required String newPassword,
  }) {
    return _noAuthClient.put<void>(
      '$_authBaseUrl/update-password',
      data: {
        'login': login,
        'newPassword': newPassword,
      },
    );
  }

  @override
  Future<InviteCodeModel> getInviteCode() {
    return _bearerClient.postType<InviteCodeModel>(
      '$_authBaseUrl/invite-code',
      fromJson: InviteCodeModel.fromJson,
    );
  }

  @override
  Future<ProfileModel> getProfile() {
    return _bearerClient.postType<ProfileModel>(
      '$_authBaseUrl/profile',
      fromJson: ProfileModel.fromJson,
    );
  }
}
