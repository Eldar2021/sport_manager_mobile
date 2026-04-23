import 'package:core/core.dart';
import 'package:meta/meta.dart';

@immutable
final class ConvertException extends AppException<Object> {
  const ConvertException(
    super.error, {
    super.stackTrace,
    super.message,
    super.type,
    super.handleType,
  });

  @override
  ErrorModel getModel() {
    return const ErrorModel(
      title: BaseMessage.base,
      message: BaseMessage.technical,
    );
  }

  @override
  BaseMessage getUiMessage() {
    return BaseMessage.technical;
  }
}
