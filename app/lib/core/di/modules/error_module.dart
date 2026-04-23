import 'dart:async';

import 'package:core/core.dart';
import 'package:get_it/get_it.dart';
import 'package:sport_manager_mobile/core/core.dart';

class ErrorModule extends BaseDiModule {
  const ErrorModule({super.scope});

  @override
  FutureOr<void> register(GetIt sl) {
    super.register(sl);
    sl
      ..registerSingleton<ErrorHandler>(
        const BaseErrorHandler(),
      )
      ..registerSingleton<ErrorHandler>(
        const ErrorHandleSnackBar(),
        instanceName: 'snackbar',
      )
      ..registerSingleton<ErrorHandler>(
        const ErrorHandleDialog(),
        instanceName: 'dialog',
      )
      ..registerSingleton<UnauthenticatedExceptionHandle>(
        const UnauthenticatedExceptionHandle(),
        instanceName: 'unauthenticated',
      );
  }
}
