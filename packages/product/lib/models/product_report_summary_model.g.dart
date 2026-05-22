// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_report_summary_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductReportSummaryModel _$ProductReportSummaryModelFromJson(
  Map<String, dynamic> json,
) => ProductReportSummaryModel(
  venueId: json['venueId'] as String,
  period: json['period'] as String,
  from: DateTime.parse(json['from'] as String),
  to: DateTime.parse(json['to'] as String),
  items: (json['items'] as List<dynamic>)
      .map((e) => ProductReportItemModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  totalAmount: (json['totalAmount'] as num).toInt(),
);

Map<String, dynamic> _$ProductReportSummaryModelToJson(
  ProductReportSummaryModel instance,
) => <String, dynamic>{
  'venueId': instance.venueId,
  'period': instance.period,
  'from': instance.from.toIso8601String(),
  'to': instance.to.toIso8601String(),
  'items': instance.items,
  'totalAmount': instance.totalAmount,
};
