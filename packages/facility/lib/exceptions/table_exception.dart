import 'package:core/core.dart';

enum TableErrorCode { notFound, numberTaken, hasActiveSession, forbidden, unknown }

final class TableException extends AppException<TableErrorCode> {
  const TableException(
    super.error, {
    super.message,
    super.handleType,
  });

  @override
  ErrorModel getModel() => ErrorModel(
    title: BaseMessage.tableError,
    message: message ?? BaseMessage.defaultUiMessage,
  );

  @override
  BaseMessage getUiMessage() => message ?? BaseMessage.defaultUiMessage;
}
