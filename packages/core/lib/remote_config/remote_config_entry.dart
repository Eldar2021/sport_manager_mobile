import 'dart:convert';
import 'package:meta/meta.dart';

@immutable
final class ConfigEntry<T> {
  const ConfigEntry({
    required this.key,
    required this.defaultRaw,
    required this.parser,
  });

  final String key;
  final String defaultRaw;
  final T Function(String raw) parser;
  T get defaultValue => parser(defaultRaw);
}

ConfigEntry<bool> boolEntry({
  required String key,
  required bool defaultValue,
}) {
  return ConfigEntry(
    key: key,
    defaultRaw: defaultValue.toString(),
    parser: (raw) => raw.toLowerCase() == 'true',
  );
}

ConfigEntry<List<T>> jsonListEntry<T>({
  required String key,
  required String defaultJson,
  required T Function(Map<String, dynamic>) fromJson,
}) {
  return ConfigEntry(
    key: key,
    defaultRaw: defaultJson,
    parser: (raw) {
      try {
        final decoded = jsonDecode(raw);
        if (decoded is List) {
          return decoded.whereType<Map<String, dynamic>>().map(fromJson).toList();
        } else {
          throw Exception('Failed to parse $key');
        }
      } on Object catch (_) {
        throw Exception('Failed to parse $key');
      }
    },
  );
}

ConfigEntry<T> jsonObjectEntry<T>({
  required String key,
  required String defaultJson,
  required T Function(Map<String, dynamic>) fromJson,
}) {
  return ConfigEntry(
    key: key,
    defaultRaw: defaultJson,
    parser: (raw) {
      try {
        final decoded = jsonDecode(raw);
        if (decoded is Map<String, dynamic>) {
          return fromJson(decoded);
        } else {
          throw Exception('Failed to parse $key');
        }
      } on Object catch (_) {
        throw Exception('Failed to parse $key');
      }
    },
  );
}
