import 'package:core/core.dart';

final class TableException extends AppException<String> {
  const TableException(
    super.error, {
    super.message,
    super.handleType,
  });

  @override
  ErrorModel getModel() => ErrorModel(
    title: const BaseMessage(
      en: 'Table Error',
      ru: 'Ошибка стола',
      ky: 'Стол катасы',
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
