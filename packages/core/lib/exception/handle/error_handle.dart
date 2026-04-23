import 'package:core/core.dart';
import 'package:flutter/material.dart';

abstract class ErrorHandler {
  const ErrorHandler();

  void handleError(
    Object? error,
    BuildContext context,
  );

  void handleAuthError(
    Object error,
    BuildContext context,
  );

  BaseMessage parseErrorMessage(Object? error) {
    return error is String
        ? BaseMessage(
            ru: error,
            en: error,
            ky: error,
          )
        : error is AppException
        ? error.getUiMessage()
        : BaseMessage.technical;
  }

  ErrorModel parseErrorModel(Object? error) {
    return error is String
        ? ErrorModel(
            title: BaseMessage.base,
            message: BaseMessage(
              ru: error,
              en: error,
              ky: error,
            ),
          )
        : error is AppException
        ? error.getModel()
        : const ErrorModel(
            title: BaseMessage.base,
            message: BaseMessage.technical,
          );
  }
}
