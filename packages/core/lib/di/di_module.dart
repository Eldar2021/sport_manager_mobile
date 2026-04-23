import 'dart:async';

import 'package:meta/meta.dart';

abstract class DIModule<T> {
  const DIModule();

  @mustCallSuper
  FutureOr<void> register(T sl);
}
