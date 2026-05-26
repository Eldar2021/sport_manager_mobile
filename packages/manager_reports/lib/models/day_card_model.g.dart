// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'day_card_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DayCardModel _$DayCardModelFromJson(Map<String, dynamic> json) => DayCardModel(
  date: DateTime.parse(json['date'] as String),
  dayOfWeek: $enumDecode(_$DayOfWeekEnumMap, json['dayOfWeek']),
  dayOfMonth: (json['dayOfMonth'] as num).toInt(),
  shortDayOfWeek: $enumDecode(_$DayOfWeekShortEnumMap, json['shortDayOfWeek']),
  revenue: (json['revenue'] as num).toInt(),
  currency: $enumDecode(_$CurrencyEnumMap, json['currency']),
  sessions: (json['sessions'] as num).toInt(),
  shiftSeconds: (json['shiftSeconds'] as num).toInt(),
  isToday: json['isToday'] as bool,
  isFuture: json['isFuture'] as bool,
  isDayOff: json['isDayOff'] as bool,
);

Map<String, dynamic> _$DayCardModelToJson(DayCardModel instance) => <String, dynamic>{
  'date': instance.date.toIso8601String(),
  'dayOfWeek': _$DayOfWeekEnumMap[instance.dayOfWeek]!,
  'dayOfMonth': instance.dayOfMonth,
  'shortDayOfWeek': _$DayOfWeekShortEnumMap[instance.shortDayOfWeek]!,
  'revenue': instance.revenue,
  'currency': _$CurrencyEnumMap[instance.currency]!,
  'sessions': instance.sessions,
  'shiftSeconds': instance.shiftSeconds,
  'isToday': instance.isToday,
  'isFuture': instance.isFuture,
  'isDayOff': instance.isDayOff,
};

const _$DayOfWeekEnumMap = {
  DayOfWeek.monday: 'MONDAY',
  DayOfWeek.tuesday: 'TUESDAY',
  DayOfWeek.wednesday: 'WEDNESDAY',
  DayOfWeek.thursday: 'THURSDAY',
  DayOfWeek.friday: 'FRIDAY',
  DayOfWeek.saturday: 'SATURDAY',
  DayOfWeek.sunday: 'SUNDAY',
};

const _$DayOfWeekShortEnumMap = {
  DayOfWeekShort.mon: 'MON',
  DayOfWeekShort.tue: 'TUE',
  DayOfWeekShort.wed: 'WED',
  DayOfWeekShort.thu: 'THU',
  DayOfWeekShort.fri: 'FRI',
  DayOfWeekShort.sat: 'SAT',
  DayOfWeekShort.sun: 'SUN',
};

const _$CurrencyEnumMap = {
  Currency.kgs: 'KGS',
  Currency.usd: 'USD',
  Currency.rub: 'RUB',
  Currency.kzt: 'KZT',
  Currency.tryLira: 'TRY',
};
