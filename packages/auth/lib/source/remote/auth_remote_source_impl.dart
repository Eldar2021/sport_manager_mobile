import 'package:api_client/api_client.dart';
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
    return _noAuthClient
        .postType<AuthResultModel>(
          '$_authBaseUrl/login',
          fromJson: AuthResultModel.fromJson,
          data: {
            'username': username,
            'password': password,
          },
        )
        .mapTo(AuthException.fromApiClientExc);
  }

  @override
  Future<AuthResultModel> register(RegisterParam param) {
    return _noAuthClient
        .postType<AuthResultModel>(
          '$_authBaseUrl/register',
          fromJson: AuthResultModel.fromJson,
          data: param.toJson(),
        )
        .mapTo(AuthException.fromApiClientExc);
  }

  @override
  Future<AuthTokensModel> refresh(String refreshToken) {
    return _bearerClient
        .postType<AuthTokensModel>(
          '$_authBaseUrl/refresh',
          fromJson: AuthTokensModel.fromJson,
          data: {'refreshToken': refreshToken},
        )
        .mapTo(AuthException.fromApiClientExc);
  }

  @override
  Future<void> logout() {
    return _bearerClient
        .post<void>('$_authBaseUrl/logout')
        .mapTo(
          AuthException.fromApiClientExc,
        );
  }

  @override
  Future<void> deleteAccount() {
    return _bearerClient
        .delete<void>('$_authBaseUrl/account')
        .mapTo(
          AuthException.fromApiClientExc,
        );
  }

  @override
  Future<void> forgotPassword(String email) {
    return _noAuthClient
        .post<void>(
          '$_authBaseUrl/forgot-password',
          data: {'email': email},
        )
        .mapTo(AuthException.fromApiClientExc);
  }

  @override
  Future<AuthTokensModel> updatePassword({
    required String login,
    required String newPassword,
  }) {
    return _bearerClient
        .postType<AuthTokensModel>(
          '$_authBaseUrl/update-password',
          fromJson: AuthTokensModel.fromJson,
          data: {
            'login': login,
            'newPassword': newPassword,
          },
        )
        .mapTo(AuthException.fromApiClientExc);
  }

  @override
  Future<InviteCodeModel> getInviteCode() {
    return _bearerClient
        .postType<InviteCodeModel>(
          '$_authBaseUrl/invite-code',
          fromJson: InviteCodeModel.fromJson,
        )
        .mapTo(AuthException.fromApiClientExc);
  }

  @override
  Future<ProfileModel> getProfile() {
    return _bearerClient
        .getType<ProfileModel>(
          '/api/v1/profile',
          fromJson: ProfileModel.fromJson,
        )
        .mapTo(AuthException.fromApiClientExc);
  }
}
