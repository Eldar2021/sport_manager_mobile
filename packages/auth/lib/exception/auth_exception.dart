import 'package:auth/exception/auth_error_code.dart';
import 'package:core/core.dart';

const _defaultUiMessage = BaseMessage(
  en: 'Authentication failed. Please try again.',
  ru: 'Ошибка входа. Повторите попытку.',
  ky: 'Кирүү катасы. Кайра аракет кылыңыз.',
);

final class AuthException extends AppException<AuthErrorCode> {
  const AuthException(
    super.error, {
    super.message,
    super.handleType,
  });

  @override
  ErrorModel getModel() => ErrorModel(
    title: BaseMessage.authException,
    message: message ?? _defaultUiMessage,
  );

  @override
  BaseMessage getUiMessage() => message ?? _defaultUiMessage;
}
