import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:sport_manager_mobile/core/core.dart';

extension ErrorHandlerContextExtension on BuildContext {
  void handleError(Object? error) {
    GetIt.I.get<ErrorHandler>().handleError(error, this);
  }

  void handleAuthError(Object error) {
    GetIt.I<UnauthenticatedExceptionHandle>(
      instanceName: 'unauthenticated',
    ).handleAuthError(error, this);
  }
}
