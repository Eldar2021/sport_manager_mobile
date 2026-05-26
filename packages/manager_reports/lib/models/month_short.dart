import 'package:json_annotation/json_annotation.dart';

@JsonEnum()
enum MonthShort {
  @JsonValue('JAN')
  jan,
  @JsonValue('FEB')
  feb,
  @JsonValue('MAR')
  mar,
  @JsonValue('APR')
  apr,
  @JsonValue('MAY')
  may,
  @JsonValue('JUN')
  jun,
  @JsonValue('JUL')
  jul,
  @JsonValue('AUG')
  aug,
  @JsonValue('SEP')
  sep,
  @JsonValue('OCT')
  oct,
  @JsonValue('NOV')
  nov,
  @JsonValue('DEC')
  dec,
}
