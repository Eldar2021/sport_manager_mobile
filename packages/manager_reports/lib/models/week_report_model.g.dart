// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'week_report_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WeekReportModel _$WeekReportModelFromJson(Map<String, dynamic> json) => WeekReportModel(
  weekStart: DateTime.parse(json['weekStart'] as String),
  weekEnd: DateTime.parse(json['weekEnd'] as String),
  summary: ReportSummaryModel.fromJson(
    json['summary'] as Map<String, dynamic>,
  ),
  days: (json['days'] as List<dynamic>).map((e) => DayCardModel.fromJson(e as Map<String, dynamic>)).toList(),
);

Map<String, dynamic> _$WeekReportModelToJson(WeekReportModel instance) => <String, dynamic>{
  'weekStart': instance.weekStart.toIso8601String(),
  'weekEnd': instance.weekEnd.toIso8601String(),
  'summary': instance.summary,
  'days': instance.days,
};
