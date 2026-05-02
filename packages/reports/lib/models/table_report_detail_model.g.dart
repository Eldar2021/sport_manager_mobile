// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'table_report_detail_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TableReportDetailModel _$TableReportDetailModelFromJson(
  Map<String, dynamic> json,
) => TableReportDetailModel(
  summary: TableReportRowModel.fromJson(
    json['summary'] as Map<String, dynamic>,
  ),
  revenueByDay: (json['revenueByDay'] as List<dynamic>)
      .map((e) => RevenuePointModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  hourHeatmap: (json['hourHeatmap'] as List<dynamic>)
      .map((e) => (e as List<dynamic>).map((e) => (e as num).toInt()).toList())
      .toList(),
);

Map<String, dynamic> _$TableReportDetailModelToJson(
  TableReportDetailModel instance,
) => <String, dynamic>{
  'summary': instance.summary,
  'revenueByDay': instance.revenueByDay,
  'hourHeatmap': instance.hourHeatmap,
};
