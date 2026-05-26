// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_summary_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReportSummaryModel _$ReportSummaryModelFromJson(Map<String, dynamic> json) => ReportSummaryModel(
  revenue: (json['revenue'] as num).toInt(),
  currency: $enumDecode(_$CurrencyEnumMap, json['currency']),
  sessions: (json['sessions'] as num).toInt(),
  shiftSeconds: (json['shiftSeconds'] as num).toInt(),
);

Map<String, dynamic> _$ReportSummaryModelToJson(ReportSummaryModel instance) => <String, dynamic>{
  'revenue': instance.revenue,
  'currency': _$CurrencyEnumMap[instance.currency]!,
  'sessions': instance.sessions,
  'shiftSeconds': instance.shiftSeconds,
};

const _$CurrencyEnumMap = {
  Currency.kgs: 'KGS',
  Currency.usd: 'USD',
  Currency.rub: 'RUB',
  Currency.kzt: 'KZT',
  Currency.tryLira: 'TRY',
};
