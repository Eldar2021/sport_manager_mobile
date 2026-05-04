import 'package:json_annotation/json_annotation.dart';

@JsonEnum()
enum ReportPeriod {
  @JsonValue('TODAY')
  today,
  @JsonValue('WEEK')
  week,
  @JsonValue('MONTH')
  month,
  @JsonValue('YEAR')
  year,
  @JsonValue('CUSTOM')
  custom,
}

extension ReportPeriodWire on ReportPeriod {
  /// Wire value sent to the backend as `?period=...`. Mirrors the
  /// `@JsonValue` annotations above so backend and mobile agree on
  /// casing without round-tripping through JsonSerializable.
  String get wireValue => switch (this) {
    ReportPeriod.today => 'TODAY',
    ReportPeriod.week => 'WEEK',
    ReportPeriod.month => 'MONTH',
    ReportPeriod.year => 'YEAR',
    ReportPeriod.custom => 'CUSTOM',
  };
}
