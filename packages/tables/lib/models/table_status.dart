import 'package:json_annotation/json_annotation.dart';

@JsonEnum()
enum TableStatus {
  @JsonValue('AVAILABLE')
  available,
  @JsonValue('OCCUPIED')
  occupied,
}
