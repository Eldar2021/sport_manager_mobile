// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'year_report_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

YearReportModel _$YearReportModelFromJson(Map<String, dynamic> json) => YearReportModel(
  year: (json['year'] as num).toInt(),
  summary: ReportSummaryModel.fromJson(
    json['summary'] as Map<String, dynamic>,
  ),
  months: (json['months'] as List<dynamic>).map((e) => MonthCardModel.fromJson(e as Map<String, dynamic>)).toList(),
);

Map<String, dynamic> _$YearReportModelToJson(YearReportModel instance) => <String, dynamic>{
  'year': instance.year,
  'summary': instance.summary,
  'months': instance.months,
};
