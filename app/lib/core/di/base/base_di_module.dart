import 'dart:async';

import 'package:core/core.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';

abstract class BaseDiModule extends DIModule<GetIt> {
  const BaseDiModule({this.scope});

  final String? scope;

  @override
  @mustCallSuper
  FutureOr<void> register(GetIt sl) {
    if (scope != null) sl.pushNewScope(scopeName: scope);
  }
}
