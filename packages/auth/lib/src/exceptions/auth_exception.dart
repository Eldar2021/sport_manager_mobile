import 'package:core/core.dart';

final class AuthException extends AppException<String> {
  const AuthException(
    super.error, {
    super.message,
    super.handleType,
  });

  @override
  ErrorModel getModel() => ErrorModel(
    title: const BaseMessage(
      en: 'Authentication Error',
      ru: 'Ошибка авторизации',
      ky: 'Авторизация катасы',
    ),
    message:
        message ??
        const BaseMessage(
          en: 'Authentication failed. Please try again.',
          ru: 'Ошибка входа. Повторите попытку.',
          ky: 'Кирүү катасы. Кайра аракет кылыңыз.',
        ),
  );

  @override
  BaseMessage getUiMessage() =>
      message ??
      const BaseMessage(
        en: 'Authentication failed. Please try again.',
        ru: 'Ошибка входа. Повторите попытку.',
        ky: 'Кирүү катасы. Кайра аракет кылыңыз.',
      );
}
