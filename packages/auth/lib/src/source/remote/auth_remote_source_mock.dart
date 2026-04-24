import 'package:auth/auth.dart';
import 'package:core/core.dart';

final class AuthRemoteSourceMock implements AuthRemoteSource {
  static const _validInviteCode = 'TF-48X2KD';
  static const _mockToken = 'mock-bearer-token-xxxx';

  static const _mockOwner = UserModel(
    id: 'u1',
    username: 'bakyt',
    name: 'Бакыт Сулайманов',
    role: UserRole.owner,
    email: 'bakyt@example.kg',
    phone: '+996 555 12 34 56',
  );

  static const _mockManager = UserModel(
    id: 'u2',
    username: 'aibek',
    name: 'Айбек Асанов',
    role: UserRole.manager,
  );

  static const _invalidCredentials = BaseMessage(
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
  Future<AuthResultModel> login({required String username, required String password}) async {
    await Future<void>.delayed(const Duration(milliseconds: 900));

    final isOwner = (username == 'bakyt' || username == 'bakyt@example.kg') && password == '12345678';
    if (isOwner) return const AuthResultModel(token: _mockToken, user: _mockOwner);

    final isManager = username == 'aibek' && password == '12345678';
    if (isManager) return const AuthResultModel(token: _mockToken, user: _mockManager);

    throw const AuthException('invalid_credentials', message: _invalidCredentials);
  }

  @override
  Future<AuthResultModel> registerOwner(RegisterOwnerBody body) async {
    await Future<void>.delayed(const Duration(milliseconds: 1100));
    return AuthResultModel(
      token: _mockToken,
      user: UserModel(
        id: 'new-owner-${DateTime.now().millisecondsSinceEpoch}',
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
      token: _mockToken,
      user: UserModel(
        id: 'new-manager-${DateTime.now().millisecondsSinceEpoch}',
        username: body.username,
        name: body.name,
        role: UserRole.manager,
      ),
    );
  }

  @override
  Future<void> forgotPassword(String email) async {
    await Future<void>.delayed(const Duration(milliseconds: 800));
  }

  @override
  Future<void> logout() async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
  }
}
