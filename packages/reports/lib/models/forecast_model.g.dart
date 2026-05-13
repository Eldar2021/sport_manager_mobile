// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'forecast_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ForecastPointModel _$ForecastPointModelFromJson(Map<String, dynamic> json) => ForecastPointModel(
  bucket: DateTime.parse(json['bucket'] as String),
  expected: (json['expected'] as num).toInt(),
  lower: (json['lower'] as num).toInt(),
  upper: (json['upper'] as num).toInt(),
  projection: json['projection'] as bool,
);

Map<String, dynamic> _$ForecastPointModelToJson(ForecastPointModel instance) => <String, dynamic>{
  'bucket': instance.bucket.toIso8601String(),
  'expected': instance.expected,
  'lower': instance.lower,
  'upper': instance.upper,
  'projection': instance.projection,
};

ForecastModel _$ForecastModelFromJson(Map<String, dynamic> json) => ForecastModel(
  points: (json['points'] as List<dynamic>).map((e) => ForecastPointModel.fromJson(e as Map<String, dynamic>)).toList(),
  projectedTotal: (json['projectedTotal'] as num).toInt(),
  previousPeriodTotal: (json['previousPeriodTotal'] as num).toInt(),
  currency: $enumDecode(_$CurrencyEnumMap, json['currency']),
);

Map<String, dynamic> _$ForecastModelToJson(ForecastModel instance) => <String, dynamic>{
  'points': instance.points,
  'projectedTotal': instance.projectedTotal,
  'previousPeriodTotal': instance.previousPeriodTotal,
  'currency': _$CurrencyEnumMap[instance.currency]!,
};

const _$CurrencyEnumMap = {
  Currency.kgs: 'KGS',
  Currency.usd: 'USD',
  Currency.rub: 'RUB',
  Currency.kzt: 'KZT',
  Currency.tryLira: 'TRY',
};
