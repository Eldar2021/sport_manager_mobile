// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'month_card_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MonthCardModel _$MonthCardModelFromJson(Map<String, dynamic> json) => MonthCardModel(
  year: (json['year'] as num).toInt(),
  month: (json['month'] as num).toInt(),
  monthShort: $enumDecode(_$MonthShortEnumMap, json['monthShort']),
  revenue: (json['revenue'] as num).toInt(),
  currency: $enumDecode(_$CurrencyEnumMap, json['currency']),
  sessions: (json['sessions'] as num).toInt(),
  shiftSeconds: (json['shiftSeconds'] as num).toInt(),
  isCurrent: json['current'] as bool,
  isFuture: json['future'] as bool,
  progressRatio: (json['progressRatio'] as num).toDouble(),
);

Map<String, dynamic> _$MonthCardModelToJson(MonthCardModel instance) => <String, dynamic>{
  'year': instance.year,
  'month': instance.month,
  'monthShort': _$MonthShortEnumMap[instance.monthShort]!,
  'revenue': instance.revenue,
  'currency': _$CurrencyEnumMap[instance.currency]!,
  'sessions': instance.sessions,
  'shiftSeconds': instance.shiftSeconds,
  'current': instance.isCurrent,
  'future': instance.isFuture,
  'progressRatio': instance.progressRatio,
};

const _$MonthShortEnumMap = {
  MonthShort.jan: 'JAN',
  MonthShort.feb: 'FEB',
  MonthShort.mar: 'MAR',
  MonthShort.apr: 'APR',
  MonthShort.may: 'MAY',
  MonthShort.jun: 'JUN',
  MonthShort.jul: 'JUL',
  MonthShort.aug: 'AUG',
  MonthShort.sep: 'SEP',
  MonthShort.oct: 'OCT',
  MonthShort.nov: 'NOV',
  MonthShort.dec: 'DEC',
};

const _$CurrencyEnumMap = {
  Currency.kgs: 'KGS',
  Currency.usd: 'USD',
  Currency.rub: 'RUB',
  Currency.kzt: 'KZT',
  Currency.tryLira: 'TRY',
};
