import 'package:auth/auth.dart';

final class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl(this._dataSource);

  final AuthDataSource _dataSource;

  @override
  Future<AuthResultModel> login({
    required String username,
    required String password,
  }) {
    return _dataSource.login(
      username: username,
      password: password,
    );
  }

  @override
  Future<AuthResultModel> registerOwner(RegisterOwnerBody body) {
    return _dataSource.registerOwner(body);
  }

  @override
  Future<AuthResultModel> registerManager(RegisterManagerBody body) {
    return _dataSource.registerManager(body);
  }
}
