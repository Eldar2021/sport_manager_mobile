import 'package:json_annotation/json_annotation.dart';

@JsonEnum()
enum TarifType {
  @JsonValue('MINUTE')
  minute,
  @JsonValue('HOUR')
  hour,
  @JsonValue('DAY')
  day
  ;

  String get label {
    return switch (this) {
      TarifType.minute => 'Minute',
      TarifType.hour => 'Hour',
      TarifType.day => 'Day',
    };
  }
}
