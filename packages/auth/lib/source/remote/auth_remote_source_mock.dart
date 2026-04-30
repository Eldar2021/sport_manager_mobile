import 'package:auth/auth.dart';
import 'package:core/core.dart';

/// Mock credentials
/// ─────────────────────────────────────────
/// Owner   │  username: test     │ password: Test1234
/// Manager │  username: manager  │ password: Test1234
/// Manager │  invite code: INVITE-001
/// ─────────────────────────────────────────
final class AuthRemoteSourceMock implements AuthRemoteSource {
  static const _ownerUsername = 'test';
  static const _managerUsername = 'manager';
  static const _password = 'Test1234';
  static const _validInviteCode = 'INVITE-001';

  static const _tokens = AuthTokensModel(
    accessToken: 'mock_access_token_abc123',
    refreshToken: 'mock_refresh_token_xyz789',
  );

  static const _testOwner = UserModel(
    id: 'user-001',
    name: 'Test Owner',
    role: UserRole.owner,
    email: 'test@tableflow.kg',
    phone: '+996 700 000 001',
  );

  static const _testManager = UserModel(
    id: 'user-002',
    name: 'Test Manager',
    role: UserRole.manager,
    email: 'manager@tableflow.kg',
    phone: '+996 700 000 002',
  );

  static const _wrongCredentials = BaseMessage(
    en: 'Invalid username or password',
    ru: 'Неверный логин или пароль',
    ky: 'Логин же сырсөз туура эмес',
  );

  static const _invalidInviteCode = BaseMessage(
    en: 'Invalid invite code',
    ru: 'Неверный код приглашения',
    ky: 'Чакыруу коду туура эмес',
  );

  @override
  Future<AuthResultModel> login({
    required String username,
    required String password,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 800));

    if (password != _password) {
      throw const AuthException(AuthErrorCode.invalidCredentials, message: _wrongCredentials);
    }

    final user = switch (username.trim()) {
      _ownerUsername => _testOwner,
      _managerUsername => _testManager,
      _ => throw const AuthException(AuthErrorCode.invalidCredentials, message: _wrongCredentials),
    };

    return AuthResultModel(
      user: user,
      accessToken: _tokens.accessToken,
      refreshToken: _tokens.refreshToken,
    );
  }

  @override
  Future<AuthResultModel> register(RegisterParam param) async {
    await Future<void>.delayed(const Duration(milliseconds: 1000));

    if (param is RegisterManagerParam && param.inviteCode.trim() != _validInviteCode) {
      throw const AuthException(AuthErrorCode.invalidInviteCode, message: _invalidInviteCode);
    }

    return AuthResultModel(
      accessToken: _tokens.accessToken,
      refreshToken: _tokens.refreshToken,
      user: UserModel(
        id: '${param.role.name}-${DateTime.now().millisecondsSinceEpoch}',
        name: param.name,
        role: param.role,
        email: param.email,
        phone: param.phone,
      ),
    );
  }

  @override
  Future<AuthTokensModel> refresh(String refreshToken) async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    return _tokens;
  }

  @override
  Future<void> forgotPassword(String email) async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
  }

  @override
  Future<void> logout() async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
  }

  @override
  Future<void> deleteAccount() async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
  }

  @override
  Future<InviteCodeModel> getInviteCode() async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    return InviteCodeModel(
      code: _validInviteCode,
      expiresAt: DateTime.now().add(const Duration(days: 7)),
    );
  }

  @override
  Future<ProfileModel> getProfile() async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    return ProfileModel(
      user: _testOwner,
      venuesCount: 3,
      managersCount: 5,
      subscriptionEndDate: DateTime.now().add(const Duration(days: 30)),
    );
  }
}
