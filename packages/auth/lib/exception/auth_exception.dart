import 'package:api_client/api_client.dart';
import 'package:core/core.dart';

enum AuthErrorCode {
  invalidCredentials,
  accountLocked,
  invalidInviteCode,
  emailAlreadyUsed,
  phoneAlreadyUsed,
  sessionExpired,
  forbidden,
  subscriptionRequired,
  unknown
  ;

  factory AuthErrorCode.fromString(String? code) {
    return switch (code) {
      'INVALID_CREDENTIALS' => .invalidCredentials,
      'ACCOUNT_LOCKED' => .accountLocked,
      'INVALID_INVITE_CODE' => .invalidInviteCode,
      'EMAIL_ALREADY_USED' => .emailAlreadyUsed,
      'PHONE_ALREADY_USED' => .phoneAlreadyUsed,
      'SESSION_EXPIRED' => .sessionExpired,
      'FORBIDDEN' => .forbidden,
      'SUBSCRIPTION_REQUIRED' => .subscriptionRequired,
      _ => .unknown,
    };
  }
}

final class AuthException extends AppException<AuthErrorCode> {
  const AuthException(
    super.error, {
    super.message,
    super.handleType,
  });

  factory AuthException.fromApiClientExc(ApiClientException e) {
    return AuthException(
      AuthErrorCode.fromString(e.code),
      message: e.message,
    );
  }

  @override
  ErrorModel getModel() => ErrorModel(
    title: _title,
    message: getUiMessage(),
  );

  BaseMessage get _title => switch (error) {
    .invalidCredentials ||
    .accountLocked ||
    .invalidInviteCode ||
    .emailAlreadyUsed ||
    .phoneAlreadyUsed ||
    .sessionExpired ||
    .forbidden ||
    .subscriptionRequired => BaseMessage.authException,
    .unknown => BaseMessage.base,
  };

  @override
  BaseMessage getUiMessage() => switch (error) {
    .invalidCredentials => const BaseMessage(
      en: 'Invalid username or password',
      ru: 'Неверный логин или пароль',
      ky: 'Логин же сырсөз туура эмес',
    ),
    .accountLocked => const BaseMessage(
      en: 'Your account has been locked',
      ru: 'Ваш аккаунт заблокирован',
      ky: 'Сиздин аккаунт бөгөттөлгөн',
    ),
    .invalidInviteCode => const BaseMessage(
      en: 'Invite code is missing, invalid, or expired',
      ru: 'Код приглашения отсутствует, неверен или истёк',
      ky: 'Чакыруу коду жок, туура эмес же мөөнөтү өткөн',
    ),
    .emailAlreadyUsed => const BaseMessage(
      en: 'This email is already registered',
      ru: 'Этот email уже зарегистрирован',
      ky: 'Бул email буга чейин катталган',
    ),
    .phoneAlreadyUsed => const BaseMessage(
      en: 'This phone number is already registered',
      ru: 'Этот номер телефона уже зарегистрирован',
      ky: 'Бул телефон номери буга чейин катталган',
    ),
    .sessionExpired => BaseMessage.sessionExpired,
    .forbidden => const BaseMessage(
      en: 'You do not have permission to perform this action',
      ru: 'У вас нет прав для выполнения этого действия',
      ky: 'Сизде бул аракетти аткаруу укугу жок',
    ),
    .subscriptionRequired => const BaseMessage(
      en: 'An active subscription is required',
      ru: 'Требуется активная подписка',
      ky: 'Активдүү жазылуу талап кылынат',
    ),
    .unknown => message ?? BaseMessage.defaultUiMessage,
  };
}
