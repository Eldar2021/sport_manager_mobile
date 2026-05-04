// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'table_report_row_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TableReportRowModel _$TableReportRowModelFromJson(Map<String, dynamic> json) => TableReportRowModel(
  tableId: json['tableId'] as String,
  tableNumber: (json['tableNumber'] as num).toInt(),
  venueId: json['venueId'] as String,
  venueName: json['venueName'] as String,
  revenue: (json['revenue'] as num).toInt(),
  sessions: (json['sessions'] as num).toInt(),
  currency: $enumDecode(_$CurrencyEnumMap, json['currency']),
  tableName: json['tableName'] as String?,
  deltaPercent: (json['deltaPercent'] as num?)?.toInt(),
);

Map<String, dynamic> _$TableReportRowModelToJson(
  TableReportRowModel instance,
) => <String, dynamic>{
  'tableId': instance.tableId,
  'tableName': instance.tableName,
  'tableNumber': instance.tableNumber,
  'venueId': instance.venueId,
  'venueName': instance.venueName,
  'revenue': instance.revenue,
  'sessions': instance.sessions,
  'currency': _$CurrencyEnumMap[instance.currency]!,
  'deltaPercent': instance.deltaPercent,
};

const _$CurrencyEnumMap = {
  Currency.kgs: 'KGS',
  Currency.usd: 'USD',
  Currency.rub: 'RUB',
  Currency.kzt: 'KZT',
  Currency.tryLira: 'TRY',
};
