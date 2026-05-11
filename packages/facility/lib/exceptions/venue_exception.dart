import 'package:core/core.dart';

enum VenueErrorCode {
  notFound,
  numberTaken,
  hasTables,
  forbidden,
  unknown
  ;

  factory VenueErrorCode.fromString(String? code) {
    switch (code) {
      case 'VENUE_NOT_FOUND':
        return VenueErrorCode.notFound;
      case 'VENUE_NUMBER_TAKEN':
        return VenueErrorCode.numberTaken;
      case 'VENUE_HAS_TABLES':
        return VenueErrorCode.hasTables;
      case 'VENUE_FORBIDDEN':
        return VenueErrorCode.forbidden;
      default:
        return VenueErrorCode.unknown;
    }
  }
}

final class VenueException extends AppException<VenueErrorCode> {
  const VenueException(
    super.error, {
    super.message,
    super.handleType,
  });

  @override
  ErrorModel getModel() => ErrorModel(
    title: BaseMessage.venueError,
    message: getUiMessage(),
  );

  @override
  BaseMessage getUiMessage() => switch (error) {
    VenueErrorCode.notFound => const BaseMessage(
      en: 'Venue not found',
      ru: 'Заведение не найдено',
      ky: 'Жай табылган жок',
    ),
    VenueErrorCode.numberTaken => const BaseMessage(
      en: 'A venue with this number already exists',
      ru: 'Заведение с таким номером уже существует',
      ky: 'Бул номер менен жай буга чейин бар',
    ),
    VenueErrorCode.hasTables => const BaseMessage(
      en: 'Cannot delete a venue that has tables',
      ru: 'Нельзя удалить заведение, в котором есть столы',
      ky: 'Столдору бар жайды жок кылуу мүмкүн эмес',
    ),
    VenueErrorCode.forbidden => const BaseMessage(
      en: 'You do not have permission to perform this action',
      ru: 'У вас нет прав для выполнения этого действия',
      ky: 'Сизде бул аракетти аткаруу укугу жок',
    ),
    VenueErrorCode.unknown => message ?? BaseMessage.defaultUiMessage,
  };
}
