import 'package:api_client/api_client.dart';
import 'package:core/core.dart';

enum FacilityErrorCode {
  venueNotFound,
  venueNumberTaken,
  venueHasSpots,
  venueForbidden,
  spotNotFound,
  spotNumberTaken,
  spotHasActiveSession,
  spotForbidden,
  noSpots,
  sessionNotFound,
  sessionNotActive,
  sessionNotPaused,
  sessionAlreadyPaused,
  sessionAlreadyCompleted,
  cancelWindowExpired,
  invalidDiscount,
  sessionForbidden,
  sessionItemNotFound,
  unknown
  ;

  factory FacilityErrorCode.fromString(String? code) {
    return switch (code) {
      'VENUE_NOT_FOUND' => .venueNotFound,
      'VENUE_NUMBER_TAKEN' => .venueNumberTaken,
      'VENUE_HAS_SPOTS' || 'VENUE_HAS_TABLES' => .venueHasSpots,
      'VENUE_FORBIDDEN' => .venueForbidden,
      'SPOT_NOT_FOUND' || 'TABLE_NOT_FOUND' => .spotNotFound,
      'SPOT_NUMBER_TAKEN' || 'TABLE_NUMBER_TAKEN' => .spotNumberTaken,
      'SPOT_HAS_ACTIVE_SESSION' || 'TABLE_HAS_ACTIVE_SESSION' => .spotHasActiveSession,
      'SPOT_FORBIDDEN' || 'TABLE_FORBIDDEN' => .spotForbidden,
      'NO_SPOTS' || 'NO_TABLES' => .noSpots,
      'SESSION_NOT_FOUND' => .sessionNotFound,
      'SESSION_NOT_ACTIVE' => .sessionNotActive,
      'SESSION_NOT_PAUSED' => .sessionNotPaused,
      'SESSION_ALREADY_PAUSED' => .sessionAlreadyPaused,
      'SESSION_ALREADY_COMPLETED' => .sessionAlreadyCompleted,
      'CANCEL_WINDOW_EXPIRED' => .cancelWindowExpired,
      'INVALID_DISCOUNT' => .invalidDiscount,
      'SESSION_FORBIDDEN' => .sessionForbidden,
      'SESSION_ITEM_NOT_FOUND' => .sessionItemNotFound,
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
    .venueNotFound || .venueNumberTaken || .venueHasSpots || .venueForbidden => BaseMessage.venueError,
    .spotNotFound || .spotNumberTaken || .spotHasActiveSession || .spotForbidden || .noSpots => BaseMessage.spotError,
    .sessionNotFound ||
    .sessionNotActive ||
    .sessionNotPaused ||
    .sessionAlreadyPaused ||
    .sessionAlreadyCompleted ||
    .cancelWindowExpired ||
    .invalidDiscount ||
    .sessionForbidden ||
    .sessionItemNotFound => BaseMessage.sessionError,
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
    .venueHasSpots => const BaseMessage(
      en: 'Cannot delete a venue that has spots',
      ru: 'Нельзя удалить заведение, в котором есть позиции',
      ky: 'Позициялары бар жайды жок кылуу мүмкүн эмес',
    ),
    .spotNotFound => const BaseMessage(
      en: 'Spot not found',
      ru: 'Позиция не найдена',
      ky: 'Позиция табылган жок',
    ),
    .spotNumberTaken => const BaseMessage(
      en: 'A spot with this number already exists',
      ru: 'Позиция с таким номером уже существует',
      ky: 'Бул номер менен позиция буга чейин бар',
    ),
    .spotHasActiveSession => const BaseMessage(
      en: 'Spot has an active session',
      ru: 'На позиции идёт активная сессия',
      ky: 'Позицияда активдүү сессия бар',
    ),
    .noSpots => const BaseMessage(
      en: 'No spots available',
      ru: 'Нет доступных позиций',
      ky: 'Жеткиликтүү позициялар жок',
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
    .sessionAlreadyPaused => const BaseMessage(
      en: 'Session is already paused',
      ru: 'Сессия уже на паузе',
      ky: 'Сессия буга чейин паузада',
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
    .sessionItemNotFound => const BaseMessage(
      en: 'Product item not found in session',
      ru: 'Товар не найден в сессии',
      ky: 'Товар сессияда табылган жок',
    ),
    .venueForbidden || .spotForbidden || .sessionForbidden => const BaseMessage(
      en: 'You do not have permission to perform this action',
      ru: 'У вас нет прав для выполнения этого действия',
      ky: 'Сизде бул аракетти аткаруу укугу жок',
    ),
    .unknown => message ?? BaseMessage.defaultUiMessage,
  };
}
