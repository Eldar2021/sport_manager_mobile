// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fraud_flag_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FraudFlagModel _$FraudFlagModelFromJson(Map<String, dynamic> json) => FraudFlagModel(
  code: $enumDecode(_$FraudFlagCodeEnumMap, json['code']),
  severity: $enumDecode(_$InsightSeverityEnumMap, json['severity']),
  value: (json['value'] as num).toDouble(),
  benchmark: (json['benchmark'] as num).toDouble(),
);

Map<String, dynamic> _$FraudFlagModelToJson(FraudFlagModel instance) => <String, dynamic>{
  'code': _$FraudFlagCodeEnumMap[instance.code]!,
  'severity': _$InsightSeverityEnumMap[instance.severity]!,
  'value': instance.value,
  'benchmark': instance.benchmark,
};

const _$FraudFlagCodeEnumMap = {
  FraudFlagCode.highCancelRate: 'HIGH_CANCEL_RATE',
  FraudFlagCode.highCancel60s: 'HIGH_CANCEL_60S',
  FraudFlagCode.highDiscountRate: 'HIGH_DISCOUNT_RATE',
  FraudFlagCode.highAvgDiscount: 'HIGH_AVG_DISCOUNT',
  FraudFlagCode.longPauseAvg: 'LONG_PAUSE_AVG',
  FraudFlagCode.manyPausePerSession: 'MANY_PAUSE_PER_SESSION',
  FraudFlagCode.offHoursActivity: 'OFF_HOURS_ACTIVITY',
  FraudFlagCode.shortSessionCluster: 'SHORT_SESSION_CLUSTER',
  FraudFlagCode.tariffOverride: 'TARIFF_OVERRIDE',
  FraudFlagCode.lowShiftRevenue: 'LOW_SHIFT_REVENUE',
  FraudFlagCode.unknown: 'UNKNOWN',
};

const _$InsightSeverityEnumMap = {
  InsightSeverity.info: 'INFO',
  InsightSeverity.warning: 'WARNING',
  InsightSeverity.critical: 'CRITICAL',
};
