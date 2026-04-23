import 'package:api_client/api_client.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';

enum UnauthenticatedExceptionHandleType {
  sessionExpired,
  userLocked
  ;

  BaseMessage getTitle(BuildContext context) {
    return BaseMessage.sessionExpired;
  }

  BaseMessage getMessage(BuildContext context) {
    return BaseMessage.sessionExpired;
  }
}

class UnauthenticatedExceptionHandle extends ErrorHandler {
  const UnauthenticatedExceptionHandle();

  @override
  void handleError(
    Object? error,
    BuildContext context, {
    UnauthenticatedExceptionHandleType type = .sessionExpired,
  }) {
    if (!context.mounted) return;
    final locale = Localizations.localeOf(context);
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog.adaptive(
          title: Text(
            type.getTitle(context).getMessage(locale.languageCode),
          ),
          content: Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Text(
              type.getMessage(context).getMessage(locale.languageCode),
              textAlign: TextAlign.center,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => _navigateToLogin(context, type),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _navigateToLogin(
    BuildContext context,
    UnauthenticatedExceptionHandleType type,
  ) {}

  @override
  void handleAuthError(Object error, BuildContext context) {
    if (error is ApiClientException) {
      if (error.error.response?.statusCode == 401) {
        handleError(error, context);
        return;
      }
      if (error.error.response?.statusCode == 423) {
        handleError(error, context, type: .userLocked);
        return;
      }
    }
  }
}
