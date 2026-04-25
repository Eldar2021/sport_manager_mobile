import 'package:json_annotation/json_annotation.dart';

@JsonEnum()
enum SessionStatus {
  @JsonValue('ACTIVE')
  active,
  @JsonValue('COMPLETED')
  completed,
  @JsonValue('CANCELLED')
  cancelled,
}
