import 'package:core/core.dart';

abstract interface class RemoteConfigRepository {
  Future<void> init(List<ConfigEntry<dynamic>> entries);

  Future<void> fetch();

  Stream<void> watch();

  T get<T>(ConfigEntry<T> entry);
}
