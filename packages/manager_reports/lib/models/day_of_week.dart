import 'package:json_annotation/json_annotation.dart';

@JsonEnum()
enum DayOfWeek {
  @JsonValue('MONDAY')
  monday,
  @JsonValue('TUESDAY')
  tuesday,
  @JsonValue('WEDNESDAY')
  wednesday,
  @JsonValue('THURSDAY')
  thursday,
  @JsonValue('FRIDAY')
  friday,
  @JsonValue('SATURDAY')
  saturday,
  @JsonValue('SUNDAY')
  sunday,
}

@JsonEnum()
enum DayOfWeekShort {
  @JsonValue('MON')
  mon,
  @JsonValue('TUE')
  tue,
  @JsonValue('WED')
  wed,
  @JsonValue('THU')
  thu,
  @JsonValue('FRI')
  fri,
  @JsonValue('SAT')
  sat,
  @JsonValue('SUN')
  sun,
}
