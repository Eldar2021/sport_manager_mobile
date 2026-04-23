import 'dart:developer';
import 'package:core/core.dart';

final class RemoteConfigRepositoryImpl implements RemoteConfigRepository {
  const RemoteConfigRepositoryImpl(this._client);

  final RemoteConfigClient _client;

  @override
  Future<void> init(List<ConfigEntry<dynamic>> entries) {
    final defaults = {
      for (final entry in entries) entry.key: entry.defaultRaw,
    };
    return _client.init(defaults);
  }

  @override
  Future<void> fetch() => _client.refresh();

  @override
  Stream<void> watch() => _client.updatesStream;

  @override
  T get<T>(ConfigEntry<T> entry) {
    final raw = _client.getString(entry.key);
    if (raw.isEmpty) return entry.defaultValue;
    try {
      return entry.parser(raw);
    } on Object catch (e, s) {
      log(
        'RemoteConfig: failed to parse "${entry.key}", using default. Error: $e',
        error: e,
        stackTrace: s,
      );
      return entry.defaultValue;
    }
  }
}
