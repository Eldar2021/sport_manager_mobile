import 'package:api_client/clients/api_client.dart';
import 'package:auth/auth.dart';
import 'package:meta/meta.dart';

@immutable
final class AuthRemoteSourceImpl implements AuthRemoteSource {
  const AuthRemoteSourceImpl(this._client);

  final ApiClient _client;

  @override
  Future<AuthResultModel> login({
    required String username,
    required String password,
  }) {
    return _client.postType<AuthResultModel>(
      '/auth/login',
      fromJson: AuthResultModel.fromJson,
      data: {'username': username, 'password': password},
    );
  }

  @override
  Future<AuthResultModel> registerOwner(RegisterOwnerBody body) {
    return _client.postType<AuthResultModel>(
      '/auth/register/owner',
      fromJson: AuthResultModel.fromJson,
      data: body.toJson(),
    );
  }

  @override
  Future<AuthResultModel> registerManager(RegisterManagerBody body) {
    return _client.postType<AuthResultModel>(
      '/auth/register/manager',
      fromJson: AuthResultModel.fromJson,
      data: body.toJson(),
    );
  }

  @override
  Future<AuthTokensModel> refresh(String refreshToken) {
    return _client.postType<AuthTokensModel>(
      '/auth/refresh',
      fromJson: AuthTokensModel.fromJson,
      data: {'refreshToken': refreshToken},
    );
  }

  @override
  Future<void> logout() {
    return _client.post('/auth/logout');
  }

  @override
  Future<void> forgotPassword(String email) {
    return _client.post(
      '/auth/forgot-password',
      data: {'email': email},
    );
  }

  @override
  Future<InviteCodeModel> getInviteCode() {
    return _client.postType<InviteCodeModel>(
      '/auth/invite-code',
      fromJson: InviteCodeModel.fromJson,
    );
  }
}
