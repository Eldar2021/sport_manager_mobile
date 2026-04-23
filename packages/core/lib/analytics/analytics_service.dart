import 'dart:async';

import 'package:core/core.dart';
import 'package:flutter/widgets.dart';

abstract interface class AnalyticsService {
  FutureOr<void> setEnabled(bool enabled);

  FutureOr<void> setUserId(String userId);

  FutureOr<void> registerEvent(AnalyticsEvent event);

  RouteObserver<ModalRoute<dynamic>> get navigationAnalyticsObserver;
}
