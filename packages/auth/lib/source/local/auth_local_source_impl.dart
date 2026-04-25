import 'dart:convert';
import 'package:auth/models/auth_tokens_model.dart';
import 'package:auth/models/user_model.dart';
import 'package:auth/source/local/auth_local_source.dart';
import 'package:storage_client/storage_client.dart';

final class AuthLocalSourceImpl implements AuthLocalSource {
  AuthLocalSourceImpl({
    required StorageInterface secure,
    required StorageInterfaceSyncRead preferences,
  }) : _secure = secure,
       _preferences = preferences;

  final StorageInterface _secure;
  final StorageInterfaceSyncRead _preferences;

  String? _cachedAccessToken;
  String? _cachedRefreshToken;

  static const _accessTokenKey = 'auth_access_token';
  static const _refreshTokenKey = 'auth_refresh_token';
  static const _userKey = 'auth_user_json';

  @override
  Future<void> saveTokens(AuthTokensModel tokens) async {
    _cachedAccessToken = tokens.accessToken;
    _cachedRefreshToken = tokens.refreshToken;
    await Future.wait([
      _secure.write(key: _accessTokenKey, value: tokens.accessToken),
      _secure.write(key: _refreshTokenKey, value: tokens.refreshToken),
    ]);
  }

  @override
  Future<AuthTokensModel?> getTokens() async {
    final access = await _secure.read(_accessTokenKey);
    final refresh = await _secure.read(_refreshTokenKey);
    if (access == null || refresh == null) return null;
    _cachedAccessToken = access;
    _cachedRefreshToken = refresh;
    return AuthTokensModel(
      accessToken: access,
      refreshToken: refresh,
    );
  }

  @override
  String? getAccessTokenSync() => _cachedAccessToken;

  @override
  String? getRefreshTokenSync() => _cachedRefreshToken;

  @override
  Future<void> saveUser(UserModel user) async {
    await _preferences.writeString(
      key: _userKey,
      value: jsonEncode(user.toJson()),
    );
  }

  @override
  UserModel? getCachedUser() {
    final json = _preferences.readString(_userKey);
    if (json == null) return null;
    try {
      final decodedJson = jsonDecode(json) as Map<String, dynamic>;
      return UserModel.fromJson(decodedJson);
    } on Object catch (_) {
      return null;
    }
  }

  @override
  Future<void> clearAll() async {
    _cachedAccessToken = null;
    _cachedRefreshToken = null;
    await Future.wait([
      _secure.delete(_accessTokenKey),
      _secure.delete(_refreshTokenKey),
      _preferences.delete(_userKey),
    ]);
  }
}
