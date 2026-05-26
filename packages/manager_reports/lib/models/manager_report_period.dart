import 'package:json_annotation/json_annotation.dart';

@JsonEnum()
enum ManagerReportPeriod {
  @JsonValue('TODAY')
  today,
  @JsonValue('WEEK')
  week,
  @JsonValue('MONTH')
  month,
  @JsonValue('YEAR')
  year
  ;

  String get wireValue => switch (this) {
    today => 'TODAY',
    week => 'WEEK',
    month => 'MONTH',
    year => 'YEAR',
  };
}
