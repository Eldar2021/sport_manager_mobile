import 'package:auth/auth.dart';
import 'package:storage_client/storage_client.dart';

final class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl(this._dataSource, this._storage);

  final AuthDataSource _dataSource;
  final StorageInterfaceSyncRead _storage;

  static const _tokenKey = 'auth_token';

  @override
  Future<AuthResultModel> login({
    required String username,
    required String password,
  }) {
    return _dataSource.login(username: username, password: password);
  }

  @override
  Future<AuthResultModel> registerOwner(RegisterOwnerBody body) {
    return _dataSource.registerOwner(body);
  }

  @override
  Future<AuthResultModel> registerManager(RegisterManagerBody body) {
    return _dataSource.registerManager(body);
  }

  @override
  Future<void> saveToken(String token) => _storage.writeString(key: _tokenKey, value: token);

  @override
  String? getToken() => _storage.readString(_tokenKey);

  @override
  Future<void> clearToken() async => _storage.delete(_tokenKey);
}
