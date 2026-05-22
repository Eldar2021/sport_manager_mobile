// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'spot_report_row_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SpotReportRowModel _$SpotReportRowModelFromJson(Map<String, dynamic> json) => SpotReportRowModel(
  spotId: json['spotId'] as String,
  spotNumber: (json['spotNumber'] as num).toInt(),
  venueId: json['venueId'] as String,
  venueName: json['venueName'] as String,
  revenue: (json['revenue'] as num).toInt(),
  sessions: (json['sessions'] as num).toInt(),
  currency: $enumDecode(_$CurrencyEnumMap, json['currency']),
  spotName: json['spotName'] as String?,
  deltaPercent: (json['deltaPercent'] as num?)?.toInt(),
);

Map<String, dynamic> _$SpotReportRowModelToJson(SpotReportRowModel instance) => <String, dynamic>{
  'spotId': instance.spotId,
  'spotName': instance.spotName,
  'spotNumber': instance.spotNumber,
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
