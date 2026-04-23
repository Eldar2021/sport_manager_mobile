import 'package:api_client/api_client.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:sport_manager_mobile/core/core.dart';

class BaseErrorHandler extends ErrorHandler {
  const BaseErrorHandler();

  @override
  void handleError(Object? error, BuildContext context) {
    final handleType = getHandleType(error);
    if (error is ApiClientException) {
      final statusCode = error.error.response?.statusCode;
      if (statusCode == 401) handleAuthError(error, context);
    }
    return switch (handleType) {
      ExceptionHandleType.dialog => GetIt.I<ErrorHandler>(
        instanceName: 'dialog',
      ).handleError(error, context),
      ExceptionHandleType.snackbar => GetIt.I<ErrorHandler>(
        instanceName: 'snackbar',
      ).handleError(error, context),
    };
  }

  ExceptionHandleType getHandleType(Object? error) {
    return error is AppException ? error.handleType : ExceptionHandleType.snackbar;
  }

  @override
  void handleAuthError(Object error, BuildContext context) {
    GetIt.I<UnauthenticatedExceptionHandle>(
      instanceName: 'unauthenticated',
    ).handleAuthError(error, context);
  }
}

class ErrorHandleDialog extends ErrorHandler {
  const ErrorHandleDialog();

  @override
  void handleError(
    Object? error,
    BuildContext context, {
    VoidCallback? onThen,
    String? description,
  }) {
    if (!context.mounted) return;
    final model = parseErrorModel(error);
    final locale = Localizations.localeOf(context).languageCode;
    showAdaptiveDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog.adaptive(
          title: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (model.icon != null)
                Padding(
                  padding: const EdgeInsetsGeometry.all(8),
                  child: model.icon,
                ),
              Text(model.title.getMessage(locale)),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(model.message.getMessage(locale)),
              const SizedBox(height: 8),
              if (description != null) Text(description),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Ok'),
            ),
          ],
        );
      },
    ).then((_) => onThen?.call());
  }

  @override
  void handleAuthError(Object error, BuildContext context) {
    GetIt.I<UnauthenticatedExceptionHandle>(
      instanceName: 'unauthenticated',
    ).handleAuthError(error, context);
  }
}

class ErrorHandleSnackBar extends ErrorHandler {
  const ErrorHandleSnackBar();

  @override
  void handleError(Object? error, BuildContext context) {
    if (!context.mounted) return;
    final locale = Localizations.localeOf(context).languageCode;
    context.showErrorSnackBar(parseErrorMessage(error).getMessage(locale));
  }

  @override
  void handleAuthError(Object error, BuildContext context) {
    GetIt.I<UnauthenticatedExceptionHandle>(
      instanceName: 'unauthenticated',
    ).handleAuthError(error, context);
  }
}
