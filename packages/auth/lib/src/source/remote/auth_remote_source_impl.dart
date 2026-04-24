import 'package:api_client/clients/api_client.dart';
import 'package:auth/auth.dart';
import 'package:meta/meta.dart';

/// {@template auth_remote_source_impl}
/// Implementation of [AuthRemoteSource]
/// {@endtemplate}
@immutable
final class AuthRemoteSourceImpl implements AuthRemoteSource {
  const AuthRemoteSourceImpl(this._apiClient);

  final ApiClient _apiClient;

  @override
  Future<AuthResultModel> login({
    required String username,
    required String password,
  }) {
    return _apiClient.postType<AuthResultModel>(
      '/api/auth/login',
      fromJson: AuthResultModel.fromJson,
      data: {
        'username': username,
        'password': password,
      },
    );
  }

  @override
  Future<AuthResultModel> registerOwner(RegisterOwnerBody body) {
    return _apiClient.postType<AuthResultModel>(
      '/api/auth/register-owner',
      fromJson: AuthResultModel.fromJson,
      data: body.toJson(),
    );
  }

  @override
  Future<AuthResultModel> registerManager(RegisterManagerBody body) {
    return _apiClient.postType<AuthResultModel>(
      '/api/auth/register-manager',
      fromJson: AuthResultModel.fromJson,
      data: body.toJson(),
    );
  }

  @override
  Future<void> logout() {
    return _apiClient.post(
      '/api/auth/logout',
    );
  }

  @override
  Future<void> forgotPassword(String email) {
    return _apiClient.post(
      '/api/auth/forgot-password',
      data: {'email': email},
    );
  }
}
