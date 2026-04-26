import 'package:core/core.dart';

const _defaultUiMessage = BaseMessage(
  en: 'Something went wrong. Please try again.',
  ru: 'Что-то пошло не так. Попробуйте ещё раз.',
  ky: 'Бир нерсе туура эмес болуп калды. Кайра аракет кылыңыз.',
);

final class TableException extends AppException<String> {
  const TableException(
    super.error, {
    super.message,
    super.handleType,
  });

  @override
  ErrorModel getModel() => ErrorModel(
    title: BaseMessage.tableError,
    message: message ?? _defaultUiMessage,
  );

  @override
  BaseMessage getUiMessage() => message ?? _defaultUiMessage;
}
