import 'package:json_annotation/json_annotation.dart';

@JsonEnum()
enum FraudFlagCode {
  @JsonValue('HIGH_CANCEL_RATE')
  highCancelRate,
  @JsonValue('HIGH_CANCEL_60S')
  highCancel60s,
  @JsonValue('HIGH_DISCOUNT_RATE')
  highDiscountRate,
  @JsonValue('HIGH_AVG_DISCOUNT')
  highAvgDiscount,
  @JsonValue('LONG_PAUSE_AVG')
  longPauseAvg,
  @JsonValue('MANY_PAUSE_PER_SESSION')
  manyPausePerSession,
  @JsonValue('OFF_HOURS_ACTIVITY')
  offHoursActivity,
  @JsonValue('SHORT_SESSION_CLUSTER')
  shortSessionCluster,
  @JsonValue('TARIFF_OVERRIDE')
  tariffOverride,
  @JsonValue('LOW_SHIFT_REVENUE')
  lowShiftRevenue,
  @JsonValue('UNKNOWN')
  unknown,
}
