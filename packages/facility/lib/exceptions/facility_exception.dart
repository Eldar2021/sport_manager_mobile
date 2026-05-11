import 'package:api_client/api_client.dart';
import 'package:core/core.dart';

enum FacilityErrorCode {
  venueNotFound,
  venueNumberTaken,
  venueHasTables,
  venueForbidden,
  tableNotFound,
  tableNumberTaken,
  tableHasActiveSession,
  tableForbidden,
  sessionNotFound,
  sessionNotActive,
  sessionNotPaused,
  sessionAlreadyCompleted,
  cancelWindowExpired,
  invalidDiscount,
  sessionForbidden,
  unknown
  ;

  factory FacilityErrorCode.fromString(String? code) {
    return switch (code) {
      'VENUE_NOT_FOUND' => FacilityErrorCode.venueNotFound,
      'VENUE_NUMBER_TAKEN' => FacilityErrorCode.venueNumberTaken,
      'VENUE_HAS_TABLES' => FacilityErrorCode.venueHasTables,
      'VENUE_FORBIDDEN' => FacilityErrorCode.venueForbidden,
      'TABLE_NOT_FOUND' => FacilityErrorCode.tableNotFound,
      'TABLE_NUMBER_TAKEN' => FacilityErrorCode.tableNumberTaken,
      'TABLE_HAS_ACTIVE_SESSION' => FacilityErrorCode.tableHasActiveSession,
      'TABLE_FORBIDDEN' => FacilityErrorCode.tableForbidden,
      'SESSION_NOT_FOUND' => FacilityErrorCode.sessionNotFound,
      'SESSION_NOT_ACTIVE' => FacilityErrorCode.sessionNotActive,
      'SESSION_NOT_PAUSED' => FacilityErrorCode.sessionNotPaused,
      'SESSION_ALREADY_COMPLETED' => FacilityErrorCode.sessionAlreadyCompleted,
      'CANCEL_WINDOW_EXPIRED' => FacilityErrorCode.cancelWindowExpired,
      'INVALID_DISCOUNT' => FacilityErrorCode.invalidDiscount,
      'SESSION_FORBIDDEN' => FacilityErrorCode.sessionForbidden,
      _ => FacilityErrorCode.unknown,
    };
  }
}

final class FacilityException extends AppException<FacilityErrorCode> {
  const FacilityException(
    super.error, {
    super.message,
    super.handleType,
  });

  factory FacilityException.fromApiClientExc(ApiClientException e) {
    return FacilityException(
      FacilityErrorCode.fromString(e.code),
      message: e.message,
    );
  }

  @override
  ErrorModel getModel() => ErrorModel(
    title: _title,
    message: getUiMessage(),
  );

  BaseMessage get _title => switch (error) {
    FacilityErrorCode.venueNotFound ||
    FacilityErrorCode.venueNumberTaken ||
    FacilityErrorCode.venueHasTables ||
    FacilityErrorCode.venueForbidden => BaseMessage.venueError,
    FacilityErrorCode.tableNotFound ||
    FacilityErrorCode.tableNumberTaken ||
    FacilityErrorCode.tableHasActiveSession ||
    FacilityErrorCode.tableForbidden => BaseMessage.tableError,
    FacilityErrorCode.sessionNotFound ||
    FacilityErrorCode.sessionNotActive ||
    FacilityErrorCode.sessionNotPaused ||
    FacilityErrorCode.sessionAlreadyCompleted ||
    FacilityErrorCode.cancelWindowExpired ||
    FacilityErrorCode.invalidDiscount ||
    FacilityErrorCode.sessionForbidden => BaseMessage.sessionError,
    FacilityErrorCode.unknown => BaseMessage.base,
  };

  @override
  BaseMessage getUiMessage() => switch (error) {
    FacilityErrorCode.venueNotFound => const BaseMessage(
      en: 'Venue not found',
      ru: 'Заведение не найдено',
      ky: 'Жай табылган жок',
    ),
    FacilityErrorCode.venueNumberTaken => const BaseMessage(
      en: 'A venue with this number already exists',
      ru: 'Заведение с таким номером уже существует',
      ky: 'Бул номер менен жай буга чейин бар',
    ),
    FacilityErrorCode.venueHasTables => const BaseMessage(
      en: 'Cannot delete a venue that has tables',
      ru: 'Нельзя удалить заведение, в котором есть столы',
      ky: 'Столдору бар жайды жок кылуу мүмкүн эмес',
    ),
    FacilityErrorCode.tableNotFound => const BaseMessage(
      en: 'Table not found',
      ru: 'Стол не найден',
      ky: 'Стол табылган жок',
    ),
    FacilityErrorCode.tableNumberTaken => const BaseMessage(
      en: 'A table with this number already exists',
      ru: 'Стол с таким номером уже существует',
      ky: 'Бул номер менен стол буга чейин бар',
    ),
    FacilityErrorCode.tableHasActiveSession => const BaseMessage(
      en: 'Table has an active session',
      ru: 'За столом идёт активная сессия',
      ky: 'Столдо активдүү сессия бар',
    ),
    FacilityErrorCode.sessionNotFound => const BaseMessage(
      en: 'Session not found',
      ru: 'Сессия не найдена',
      ky: 'Сессия табылган жок',
    ),
    FacilityErrorCode.sessionNotActive => const BaseMessage(
      en: 'Session is not active',
      ru: 'Сессия не является активной',
      ky: 'Сессия активдүү эмес',
    ),
    FacilityErrorCode.sessionNotPaused => const BaseMessage(
      en: 'Session is not paused',
      ru: 'Сессия не на паузе',
      ky: 'Сессия паузада эмес',
    ),
    FacilityErrorCode.sessionAlreadyCompleted => const BaseMessage(
      en: 'Session is already completed',
      ru: 'Сессия уже завершена',
      ky: 'Сессия буга чейин аяктаган',
    ),
    FacilityErrorCode.cancelWindowExpired => const BaseMessage(
      en: 'Cancellation window has expired (60 seconds)',
      ru: 'Окно отмены истекло (60 секунд)',
      ky: 'Жокко чыгаруу терезеси өтүп кетти (60 секунд)',
    ),
    FacilityErrorCode.invalidDiscount => const BaseMessage(
      en: 'Discount must be between 0 and 100',
      ru: 'Скидка должна быть от 0 до 100',
      ky: 'Арзандатуу 0 менен 100 арасында болушу керек',
    ),
    FacilityErrorCode.venueForbidden ||
    FacilityErrorCode.tableForbidden ||
    FacilityErrorCode.sessionForbidden => const BaseMessage(
      en: 'You do not have permission to perform this action',
      ru: 'У вас нет прав для выполнения этого действия',
      ky: 'Сизде бул аракетти аткаруу укугу жок',
    ),
    FacilityErrorCode.unknown => message ?? BaseMessage.defaultUiMessage,
  };
}
