import 'package:json_annotation/json_annotation.dart';

@JsonEnum()
enum TarifType {
  @JsonValue('MINUTE')
  minute,
  @JsonValue('HOUR')
  hour,
  @JsonValue('DAY')
  day,
}
