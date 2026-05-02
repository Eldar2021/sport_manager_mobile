// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'manager_report_row_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ManagerReportRowModel _$ManagerReportRowModelFromJson(
  Map<String, dynamic> json,
) => ManagerReportRowModel(
  managerId: json['managerId'] as String,
  name: json['name'] as String,
  username: json['username'] as String,
  revenue: (json['revenue'] as num).toInt(),
  sessions: (json['sessions'] as num).toInt(),
  cancelCount: (json['cancelCount'] as num).toInt(),
  currency: $enumDecode(_$CurrencyEnumMap, json['currency']),
);

Map<String, dynamic> _$ManagerReportRowModelToJson(
  ManagerReportRowModel instance,
) => <String, dynamic>{
  'managerId': instance.managerId,
  'name': instance.name,
  'username': instance.username,
  'revenue': instance.revenue,
  'sessions': instance.sessions,
  'cancelCount': instance.cancelCount,
  'currency': _$CurrencyEnumMap[instance.currency]!,
};

const _$CurrencyEnumMap = {
  Currency.kgs: 'KGS',
  Currency.usd: 'USD',
  Currency.rub: 'RUB',
  Currency.kzt: 'KZT',
  Currency.tryLira: 'TRY',
};
