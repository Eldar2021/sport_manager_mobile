import 'dart:async';

import 'package:core/core.dart';
import 'package:flutter/widgets.dart';

abstract interface class AnalyticsClient {
  FutureOr<void> setEnabled(bool enabled);

  FutureOr<void> setUserId(String userId);

  List<RouteObserver<ModalRoute<dynamic>>> get navigationAnalyticsObservers;

  FutureOr<void> openApp();

  FutureOr<void> login(Map<String, Object> parameters);

  FutureOr<void> logout(Map<String, Object> parameters);

  FutureOr<void> tap(Map<String, Object> parameters);

  FutureOr<void> select(Map<String, Object> parameters);
}

@immutable
final class AnalyticsClientImpl implements AnalyticsClient {
  const AnalyticsClientImpl(this.service);

  final AnalyticsService service;

  @override
  FutureOr<void> setEnabled(bool enabled) => service.setEnabled(enabled);

  @override
  FutureOr<void> setUserId(String userId) => service.setUserId(userId);

  @override
  List<RouteObserver<ModalRoute<dynamic>>> get navigationAnalyticsObservers {
    return [service.navigationAnalyticsObserver];
  }

  @override
  FutureOr<void> openApp() => service.registerEvent(const AnalyticsEvent(name: 'open_app'));

  @override
  FutureOr<void> login(Map<String, Object> parameters) {
    return service.registerEvent(AnalyticsEvent(name: 'login', parameters: parameters));
  }

  @override
  FutureOr<void> logout(Map<String, Object> parameters) {
    return service.registerEvent(AnalyticsEvent(name: 'logout', parameters: parameters));
  }

  @override
  FutureOr<void> tap(Map<String, Object> parameters) {
    return service.registerEvent(AnalyticsEvent(name: 'tap', parameters: parameters));
  }

  @override
  FutureOr<void> select(Map<String, Object> parameters) {
    return service.registerEvent(AnalyticsEvent(name: 'select', parameters: parameters));
  }
}
