import 'package:core/core.dart';

enum SessionErrorCode {
  sessionNotFound,
  tableNotFound,
  tableHasActiveSession,
  sessionNotActive,
  sessionNotPaused,
  sessionAlreadyCompleted,
  cancelWindowExpired,
  invalidDiscount,
  forbidden,
  unknown,
}

final class SessionException extends AppException<SessionErrorCode> {
  const SessionException(
    super.error, {
    super.message,
    super.handleType,
  });

  @override
  ErrorModel getModel() => ErrorModel(
    title: BaseMessage.sessionError,
    message: getUiMessage(),
  );

  @override
  BaseMessage getUiMessage() => switch (error) {
    SessionErrorCode.sessionNotFound => const BaseMessage(
      en: 'Session not found',
      ru: 'Сессия не найдена',
      ky: 'Сессия табылган жок',
    ),
    SessionErrorCode.tableNotFound => const BaseMessage(
      en: 'Table not found',
      ru: 'Стол не найден',
      ky: 'Стол табылган жок',
    ),
    SessionErrorCode.tableHasActiveSession => const BaseMessage(
      en: 'Table already has an active session',
      ru: 'За этим столом уже идёт активная сессия',
      ky: 'Бул столдо активдүү сессия буга чейин бар',
    ),
    SessionErrorCode.sessionNotActive => const BaseMessage(
      en: 'Session is not active',
      ru: 'Сессия не является активной',
      ky: 'Сессия активдүү эмес',
    ),
    SessionErrorCode.sessionNotPaused => const BaseMessage(
      en: 'Session is not paused',
      ru: 'Сессия не на паузе',
      ky: 'Сессия паузада эмес',
    ),
    SessionErrorCode.sessionAlreadyCompleted => const BaseMessage(
      en: 'Session is already completed',
      ru: 'Сессия уже завершена',
      ky: 'Сессия буга чейин аяктаган',
    ),
    SessionErrorCode.cancelWindowExpired => const BaseMessage(
      en: 'Cancellation window has expired (60 seconds)',
      ru: 'Окно отмены истекло (60 секунд)',
      ky: 'Жокко чыгаруу терезеси өтүп кетти (60 секунд)',
    ),
    SessionErrorCode.invalidDiscount => const BaseMessage(
      en: 'Discount must be between 0 and 100',
      ru: 'Скидка должна быть от 0 до 100',
      ky: 'Арзандатуу 0 менен 100 арасында болушу керек',
    ),
    SessionErrorCode.forbidden => const BaseMessage(
      en: 'You do not have permission to perform this action',
      ru: 'У вас нет прав для выполнения этого действия',
      ky: 'Сизде бул аракетти аткаруу укугу жок',
    ),
    SessionErrorCode.unknown => message ?? BaseMessage.defaultUiMessage,
  };
}
