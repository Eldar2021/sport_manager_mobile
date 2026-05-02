import 'package:json_annotation/json_annotation.dart';

@JsonEnum()
enum InsightSeverity {
  @JsonValue('INFO')
  info,
  @JsonValue('WARNING')
  warning,
  @JsonValue('CRITICAL')
  critical,
}
