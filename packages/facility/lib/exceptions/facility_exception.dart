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
      'VENUE_NOT_FOUND' => .venueNotFound,
      'VENUE_NUMBER_TAKEN' => .venueNumberTaken,
      'VENUE_HAS_TABLES' => .venueHasTables,
      'VENUE_FORBIDDEN' => .venueForbidden,
      'TABLE_NOT_FOUND' => .tableNotFound,
      'TABLE_NUMBER_TAKEN' => .tableNumberTaken,
      'TABLE_HAS_ACTIVE_SESSION' => .tableHasActiveSession,
      'TABLE_FORBIDDEN' => .tableForbidden,
      'SESSION_NOT_FOUND' => .sessionNotFound,
      'SESSION_NOT_ACTIVE' => .sessionNotActive,
      'SESSION_NOT_PAUSED' => .sessionNotPaused,
      'SESSION_ALREADY_COMPLETED' => .sessionAlreadyCompleted,
      'CANCEL_WINDOW_EXPIRED' => .cancelWindowExpired,
      'INVALID_DISCOUNT' => .invalidDiscount,
      'SESSION_FORBIDDEN' => .sessionForbidden,
      _ => .unknown,
    };
  }
}

final class FacilityExc extends AppException<FacilityErrorCode> {
  const FacilityExc(
    super.error, {
    super.message,
    super.handleType,
  });

  factory FacilityExc.fromApiClientExc(ApiClientException e) {
    return FacilityExc(
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
    .venueNotFound || .venueNumberTaken || .venueHasTables || .venueForbidden => BaseMessage.venueError,
    .tableNotFound || .tableNumberTaken || .tableHasActiveSession || .tableForbidden => BaseMessage.tableError,
    .sessionNotFound ||
    .sessionNotActive ||
    .sessionNotPaused ||
    .sessionAlreadyCompleted ||
    .cancelWindowExpired ||
    .invalidDiscount ||
    .sessionForbidden => BaseMessage.sessionError,
    .unknown => BaseMessage.base,
  };

  @override
  BaseMessage getUiMessage() => switch (error) {
    .venueNotFound => const BaseMessage(
      en: 'Venue not found',
      ru: 'Заведение не найдено',
      ky: 'Жай табылган жок',
    ),
    .venueNumberTaken => const BaseMessage(
      en: 'A venue with this number already exists',
      ru: 'Заведение с таким номером уже существует',
      ky: 'Бул номер менен жай буга чейин бар',
    ),
    .venueHasTables => const BaseMessage(
      en: 'Cannot delete a venue that has tables',
      ru: 'Нельзя удалить заведение, в котором есть столы',
      ky: 'Столдору бар жайды жок кылуу мүмкүн эмес',
    ),
    .tableNotFound => const BaseMessage(
      en: 'Table not found',
      ru: 'Стол не найден',
      ky: 'Стол табылган жок',
    ),
    .tableNumberTaken => const BaseMessage(
      en: 'A table with this number already exists',
      ru: 'Стол с таким номером уже существует',
      ky: 'Бул номер менен стол буга чейин бар',
    ),
    .tableHasActiveSession => const BaseMessage(
      en: 'Table has an active session',
      ru: 'За столом идёт активная сессия',
      ky: 'Столдо активдүү сессия бар',
    ),
    .sessionNotFound => const BaseMessage(
      en: 'Session not found',
      ru: 'Сессия не найдена',
      ky: 'Сессия табылган жок',
    ),
    .sessionNotActive => const BaseMessage(
      en: 'Session is not active',
      ru: 'Сессия не является активной',
      ky: 'Сессия активдүү эмес',
    ),
    .sessionNotPaused => const BaseMessage(
      en: 'Session is not paused',
      ru: 'Сессия не на паузе',
      ky: 'Сессия паузада эмес',
    ),
    .sessionAlreadyCompleted => const BaseMessage(
      en: 'Session is already completed',
      ru: 'Сессия уже завершена',
      ky: 'Сессия буга чейин аяктаган',
    ),
    .cancelWindowExpired => const BaseMessage(
      en: 'Cancellation window has expired (60 seconds)',
      ru: 'Окно отмены истекло (60 секунд)',
      ky: 'Жокко чыгаруу терезеси өтүп кетти (60 секунд)',
    ),
    .invalidDiscount => const BaseMessage(
      en: 'Discount must be between 0 and 100',
      ru: 'Скидка должна быть от 0 до 100',
      ky: 'Арзандатуу 0 менен 100 арасында болушу керек',
    ),
    .venueForbidden || .tableForbidden || .sessionForbidden => const BaseMessage(
      en: 'You do not have permission to perform this action',
      ru: 'У вас нет прав для выполнения этого действия',
      ky: 'Сизде бул аракетти аткаруу укугу жок',
    ),
    .unknown => message ?? BaseMessage.defaultUiMessage,
  };
}
