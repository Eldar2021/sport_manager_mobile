import 'package:auth/auth.dart';
import 'package:flutter/foundation.dart';
import 'package:storage_client/storage_client.dart';

/// {@template auth_local_source_impl}
/// Implementation of [AuthLocalSource]
/// {@endtemplate}
@immutable
final class AuthLocalSourceImpl implements AuthLocalSource {
  const AuthLocalSourceImpl(this._storage);

  final StorageInterfaceSyncRead _storage;

  static const String _tokenKey = 'auth_token';

  @override
  Future<void> saveTokens(String token) {
    return _storage.writeString(
      key: _tokenKey,
      value: token,
    );
  }

  @override
  Future<void> clearTokens() async {
    await _storage.delete(_tokenKey);
  }

  @override
  String? getToken() {
    return _storage.readString(_tokenKey);
  }
}
