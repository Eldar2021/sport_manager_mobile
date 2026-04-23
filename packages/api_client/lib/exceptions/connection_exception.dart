import 'package:core/core.dart';
import 'package:meta/meta.dart';

@immutable
final class ConnectionException extends AppException<Object> {
  const ConnectionException(
    super.error, {
    super.handleType = ExceptionHandleType.dialog,
    super.stackTrace,
    super.message,
    super.type,
  });

  @override
  ErrorModel getModel() {
    return const ErrorModel(
      title: BaseMessage.connection,
      message: BaseMessage.noInternetConnection,
    );
  }

  @override
  BaseMessage getUiMessage() {
    return BaseMessage.noInternetConnection;
  }
}
