import 'package:core/core.dart';

final class SessionException extends AppException<String> {
  const SessionException(
    super.error, {
    super.message,
    super.handleType,
  });

  @override
  ErrorModel getModel() => ErrorModel(
    title: const BaseMessage(
      en: 'Session Error',
      ru: 'Ошибка сессии',
      ky: 'Сессия катасы',
    ),
    message:
        message ??
        const BaseMessage(
          en: 'Something went wrong. Please try again.',
          ru: 'Что-то пошло не так. Попробуйте ещё раз.',
          ky: 'Бир нерсе туура эмес болуп калды. Кайра аракет кылыңыз.',
        ),
  );

  @override
  BaseMessage getUiMessage() =>
      message ??
      const BaseMessage(
        en: 'Something went wrong. Please try again.',
        ru: 'Что-то пошло не так. Попробуйте ещё раз.',
        ky: 'Бир нерсе туура эмес болуп калды. Кайра аракет кылыңыз.',
      );
}
