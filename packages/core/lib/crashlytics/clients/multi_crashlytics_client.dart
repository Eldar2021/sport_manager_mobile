import 'dart:async';

import 'package:core/core.dart';

abstract interface class MultiCrashlyticsClient implements CrashlyticsClient {
  void addService(CrashlyticsService service);

  void removeService(CrashlyticsService service);
}

final class MultiCrashlyticsClientImpl implements MultiCrashlyticsClient {
  MultiCrashlyticsClientImpl(this.services);

  final List<CrashlyticsService> services;

  @override
  void addService(CrashlyticsService service) {
    if (services.contains(service)) return;
    services.add(service);
  }

  @override
  void removeService(CrashlyticsService service) {
    if (!services.contains(service)) return;
    services.remove(service);
  }

  @override
  void setEnabled(bool enabled) {
    for (final service in services) {
      service.setEnabled(enabled);
    }
  }

  @override
  FutureOr<void> report(
    Object error,
    StackTrace? stack, {
    bool fatal = false,
  }) {
    for (final service in services) {
      service.report(error, stack, fatal: fatal);
    }
  }
}
