import 'package:auth/auth.dart';
import 'package:core/core.dart';

final class AuthRemoteSourceMock implements AuthRemoteSource {
  static const _validInviteCode = 'TF-TEST1';

  static const _mockTokens = AuthTokensModel(
    accessToken: 'mock-access-token',
    refreshToken: 'mock-refresh-token',
  );

  static const _invalidInviteCode = BaseMessage(
    en: 'Invalid or expired invite code',
    ru: 'Неверный или истёкший код приглашения',
    ky: 'Жараксыз же мөөнөтү өткөн чакыруу коду',
  );

  @override
  Future<AuthResultModel> login({
    required String username,
    required String password,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 900));

    final role = username == 'manager' ? UserRole.manager : UserRole.owner;
    final user = UserModel(
      id: 'mock-user-1',
      username: username,
      name: role == UserRole.manager ? 'Менеджер' : 'Владелец',
      role: role,
      email: role == UserRole.owner ? '$username@example.kg' : null,
    );

    return AuthResultModel(
      user: user,
      accessToken: _mockTokens.accessToken,
      refreshToken: _mockTokens.refreshToken,
    );
  }

  @override
  Future<AuthResultModel> registerOwner(RegisterOwnerBody body) async {
    await Future<void>.delayed(const Duration(milliseconds: 1100));

    return AuthResultModel(
      accessToken: _mockTokens.accessToken,
      refreshToken: _mockTokens.refreshToken,
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
    await Future<void>.delayed(const Duration(milliseconds: 900));

    if (body.inviteCode.trim().toUpperCase() != _validInviteCode) {
      throw const AuthException('invalid_invite_code', message: _invalidInviteCode);
    }

    return AuthResultModel(
      accessToken: _mockTokens.accessToken,
      refreshToken: _mockTokens.refreshToken,
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
    await Future<void>.delayed(const Duration(milliseconds: 500));
    return _mockTokens;
  }

  @override
  Future<void> forgotPassword(String email) async {
    await Future<void>.delayed(const Duration(milliseconds: 800));
  }

  @override
  Future<void> logout() async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
  }

  @override
  Future<InviteCodeModel> getInviteCode() async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
    return InviteCodeModel(
      code: 'TF-TEST1',
      expiresAt: DateTime.now().add(const Duration(days: 7)),
    );
  }
}
