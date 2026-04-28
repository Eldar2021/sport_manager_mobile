import 'package:core/core.dart';

enum VenueErrorCode { notFound, numberTaken, hasTables, forbidden, unknown }

final class VenueException extends AppException<VenueErrorCode> {
  const VenueException(
    super.error, {
    super.message,
    super.handleType,
  });

  @override
  ErrorModel getModel() => ErrorModel(
    title: BaseMessage.venueError,
    message: message ?? BaseMessage.defaultUiMessage,
  );

  @override
  BaseMessage getUiMessage() => message ?? BaseMessage.defaultUiMessage;
}
