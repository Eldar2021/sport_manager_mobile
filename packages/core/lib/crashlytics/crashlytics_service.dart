import 'dart:async';

abstract interface class CrashlyticsService {
  FutureOr<void> setEnabled(bool enabled);

  FutureOr<void> report(
    Object error,
    StackTrace? stack, {
    bool fatal = false,
  });
}
