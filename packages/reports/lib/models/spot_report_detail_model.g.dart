// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'spot_report_detail_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SpotReportDetailModel _$SpotReportDetailModelFromJson(
  Map<String, dynamic> json,
) => SpotReportDetailModel(
  summary: SpotReportRowModel.fromJson(json['summary'] as Map<String, dynamic>),
  revenueSeries: (json['revenueSeries'] as List<dynamic>)
      .map((e) => RevenuePointModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  hourHeatmap: (json['hourHeatmap'] as List<dynamic>)
      .map((e) => (e as List<dynamic>).map((e) => (e as num).toInt()).toList())
      .toList(),
);

Map<String, dynamic> _$SpotReportDetailModelToJson(
  SpotReportDetailModel instance,
) => <String, dynamic>{
  'summary': instance.summary,
  'revenueSeries': instance.revenueSeries,
  'hourHeatmap': instance.hourHeatmap,
};
