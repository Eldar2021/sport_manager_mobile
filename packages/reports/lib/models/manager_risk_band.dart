import 'package:json_annotation/json_annotation.dart';

@JsonEnum()
enum ManagerRiskBand {
  @JsonValue('GREEN')
  green,
  @JsonValue('YELLOW')
  yellow,
  @JsonValue('RED')
  red,
}
