import 'package:auth/auth.dart';
import 'package:meta/meta.dart';

/// {@template auth_repository}
/// Repository for authentication operations.
/// {@endtemplate}
@immutable
final class AuthRepository {
  const AuthRepository({
    required this.remote,
    required this.local,
  });

  final AuthRemoteSource remote;
  final AuthLocalSource local;

  Future<AuthResultModel> login({
    required String username,
    required String password,
  }) async {
    final result = await remote.login(
      username: username,
      password: password,
    );

    await local.saveTokens(result.token);

    return result;
  }

  Future<AuthResultModel> registerOwner(RegisterOwnerBody body) async {
    final result = await remote.registerOwner(body);
    await local.saveTokens(result.token);
    return result;
  }

  Future<AuthResultModel> registerManager(RegisterManagerBody body) async {
    final result = await remote.registerManager(body);
    await local.saveTokens(result.token);
    return result;
  }

  Future<void> forgotPassword(String email) {
    return remote.forgotPassword(email);
  }

  String? getToken() => local.getToken();

  Future<void> logout() async {
    await local.clearTokens();
    await remote.logout();
  }
}
