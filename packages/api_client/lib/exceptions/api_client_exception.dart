import 'package:api_client/api_client.dart';
import 'package:core/core.dart';
import 'package:meta/meta.dart';

@immutable
final class ApiClientException extends AppException<DioException> {
  const ApiClientException(
    super.error, {
    super.message,
    super.stackTrace,
    super.type,
    super.handleType,
  });

  @override
  ErrorModel getModel() {
    return ErrorModel(
      title: BaseMessage.base,
      message: message ?? BaseMessage.technical,
    );
  }

  @override
  BaseMessage getUiMessage() {
    final message = error.errorMessage;
    if (message != null) return message;
    return BaseMessage.base;
  }
}

@immutable
final class ApiClientUnknownException extends AppException<Object> {
  const ApiClientUnknownException(
    super.error, {
    super.stackTrace,
    super.message,
  });

  @override
  ErrorModel getModel() {
    return ErrorModel(
      title: BaseMessage.base,
      message: message ?? BaseMessage.base,
    );
  }

  @override
  BaseMessage getUiMessage() {
    return message ?? BaseMessage.base;
  }
}
