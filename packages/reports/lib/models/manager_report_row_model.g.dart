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
  discountedCount: (json['discountedCount'] as num).toInt(),
  avgDiscountPercent: (json['avgDiscountPercent'] as num).toInt(),
  riskScore: (json['riskScore'] as num).toInt(),
  riskBand: $enumDecode(_$ManagerRiskBandEnumMap, json['riskBand']),
  flags: (json['flags'] as List<dynamic>).map((e) => FraudFlagModel.fromJson(e as Map<String, dynamic>)).toList(),
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
  'discountedCount': instance.discountedCount,
  'avgDiscountPercent': instance.avgDiscountPercent,
  'riskScore': instance.riskScore,
  'riskBand': _$ManagerRiskBandEnumMap[instance.riskBand]!,
  'flags': instance.flags,
  'currency': _$CurrencyEnumMap[instance.currency]!,
};

const _$ManagerRiskBandEnumMap = {
  ManagerRiskBand.green: 'GREEN',
  ManagerRiskBand.yellow: 'YELLOW',
  ManagerRiskBand.red: 'RED',
};

const _$CurrencyEnumMap = {
  Currency.kgs: 'KGS',
  Currency.usd: 'USD',
  Currency.rub: 'RUB',
  Currency.kzt: 'KZT',
  Currency.tryLira: 'TRY',
};
