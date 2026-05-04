// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reports_summary_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReportsSummaryModel _$ReportsSummaryModelFromJson(Map<String, dynamic> json) => ReportsSummaryModel(
  totalRevenue: (json['totalRevenue'] as num).toInt(),
  totalSessions: (json['totalSessions'] as num).toInt(),
  cancelledSessions: (json['cancelledSessions'] as num).toInt(),
  currency: $enumDecode(_$CurrencyEnumMap, json['currency']),
  previous: json['previous'] == null
      ? null
      : ReportsSummaryModel.fromJson(
          json['previous'] as Map<String, dynamic>,
        ),
);

Map<String, dynamic> _$ReportsSummaryModelToJson(
  ReportsSummaryModel instance,
) => <String, dynamic>{
  'totalRevenue': instance.totalRevenue,
  'totalSessions': instance.totalSessions,
  'cancelledSessions': instance.cancelledSessions,
  'currency': _$CurrencyEnumMap[instance.currency]!,
  'previous': instance.previous,
};

const _$CurrencyEnumMap = {
  Currency.kgs: 'KGS',
  Currency.usd: 'USD',
  Currency.rub: 'RUB',
  Currency.kzt: 'KZT',
  Currency.tryLira: 'TRY',
};
