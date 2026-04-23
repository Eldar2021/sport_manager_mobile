import 'package:core/core.dart';
import 'package:flutter/material.dart';

@immutable
final class StorageException extends AppException<Object> {
  const StorageException(
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
