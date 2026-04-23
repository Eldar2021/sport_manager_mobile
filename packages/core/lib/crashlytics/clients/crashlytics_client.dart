import 'dart:async';

import 'package:core/core.dart';
import 'package:meta/meta.dart';

abstract interface class CrashlyticsClient {
  FutureOr<void> setEnabled(bool enabled);

  FutureOr<void> report(
    Object error,
    StackTrace? stack, {
    bool fatal = false,
  });
}

@immutable
final class CrashlyticsClientImpl implements CrashlyticsClient {
  const CrashlyticsClientImpl(this.service);

  final CrashlyticsService service;

  @override
  FutureOr<void> setEnabled(bool enabled) {
    return service.setEnabled(enabled);
  }

  @override
  FutureOr<void> report(
    Object error,
    StackTrace? stack, {
    bool fatal = false,
  }) {
    return service.report(error, stack, fatal: fatal);
  }
}
