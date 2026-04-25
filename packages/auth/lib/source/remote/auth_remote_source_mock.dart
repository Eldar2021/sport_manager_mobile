import 'package:auth/auth.dart';
import 'package:core/core.dart';

/// Mock credentials
/// ─────────────────────────────────────────
/// Login   │  username: test  │ password: Test1234
/// Manager │  invite code: INVITE-001
/// ─────────────────────────────────────────
final class AuthRemoteSourceMock implements AuthRemoteSource {
  static const _username = 'test';
  static const _password = 'Test1234';
  static const _validInviteCode = 'INVITE-001';

  static const _tokens = AuthTokensModel(
    accessToken: 'mock_access_token_abc123',
    refreshToken: 'mock_refresh_token_xyz789',
  );

  static const _testOwner = UserModel(
    id: 'user-001',
    username: _username,
    name: 'Test Owner',
    role: UserRole.owner,
    email: 'test@tableflow.kg',
    phone: '+996 700 000 001',
  );

  static const _wrongCredentials = BaseMessage(
    en: 'Invalid username or password',
    ru: 'Неверный логин или пароль',
    ky: 'Логин же сырсөз туура эмес',
  );

  static const _badInviteCode = BaseMessage(
    en: 'Invalid or expired invite code',
    ru: 'Неверный или истёкший код приглашения',
    ky: 'Жараксыз же мөөнөтү өткөн чакыруу коду',
  );

  @override
  Future<AuthResultModel> login({
    required String username,
    required String password,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 800));

    if (username.trim() != _username || password != _password) {
      throw const AuthException('invalid_credentials', message: _wrongCredentials);
    }

    return AuthResultModel(
      user: _testOwner,
      accessToken: _tokens.accessToken,
      refreshToken: _tokens.refreshToken,
    );
  }

  @override
  Future<AuthResultModel> registerOwner(RegisterOwnerBody body) async {
    await Future<void>.delayed(const Duration(milliseconds: 1000));

    return AuthResultModel(
      accessToken: _tokens.accessToken,
      refreshToken: _tokens.refreshToken,
      user: UserModel(
        id: 'owner-${DateTime.now().millisecondsSinceEpoch}',
        username: body.email.split('@').first,
        name: body.name,
        role: UserRole.owner,
        email: body.email,
        phone: body.phone,
      ),
    );
  }

  @override
  Future<AuthResultModel> registerManager(RegisterManagerBody body) async {
    await Future<void>.delayed(const Duration(milliseconds: 800));

    if (body.inviteCode.trim().toUpperCase() != _validInviteCode) {
      throw const AuthException('invalid_invite_code', message: _badInviteCode);
    }

    return AuthResultModel(
      accessToken: _tokens.accessToken,
      refreshToken: _tokens.refreshToken,
      user: UserModel(
        id: 'manager-${DateTime.now().millisecondsSinceEpoch}',
        username: body.username,
        name: body.name,
        role: UserRole.manager,
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
  Future<InviteCodeModel> getInviteCode() async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    return InviteCodeModel(
      code: _validInviteCode,
      expiresAt: DateTime.now().add(const Duration(days: 7)),
    );
  }
}
