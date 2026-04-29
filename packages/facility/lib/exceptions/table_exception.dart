import 'package:core/core.dart';

enum TableErrorCode {
  notFound,
  numberTaken,
  hasActiveSession,
  forbidden,
  unknown,
}

final class TableException extends AppException<TableErrorCode> {
  const TableException(
    super.error, {
    super.message,
    super.handleType,
  });

  @override
  ErrorModel getModel() => ErrorModel(
    title: BaseMessage.tableError,
    message: getUiMessage(),
  );

  @override
  BaseMessage getUiMessage() => switch (error) {
    TableErrorCode.notFound => const BaseMessage(
      en: 'Table not found',
      ru: 'Стол не найден',
      ky: 'Стол табылган жок',
    ),
    TableErrorCode.numberTaken => const BaseMessage(
      en: 'A table with this number already exists',
      ru: 'Стол с таким номером уже существует',
      ky: 'Бул номер менен стол буга чейин бар',
    ),
    TableErrorCode.hasActiveSession => const BaseMessage(
      en: 'Table has an active session',
      ru: 'За столом идёт активная сессия',
      ky: 'Столдо активдүү сессия бар',
    ),
    TableErrorCode.forbidden => const BaseMessage(
      en: 'You do not have permission to perform this action',
      ru: 'У вас нет прав для выполнения этого действия',
      ky: 'Сизде бул аракетти аткаруу укугу жок',
    ),
    TableErrorCode.unknown => message ?? BaseMessage.defaultUiMessage,
  };
}
