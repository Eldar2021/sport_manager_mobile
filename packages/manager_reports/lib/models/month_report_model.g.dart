// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'month_report_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MonthReportModel _$MonthReportModelFromJson(Map<String, dynamic> json) => MonthReportModel(
  year: (json['year'] as num).toInt(),
  month: (json['month'] as num).toInt(),
  monthShort: $enumDecode(_$MonthShortEnumMap, json['monthShort']),
  summary: ReportSummaryModel.fromJson(
    json['summary'] as Map<String, dynamic>,
  ),
  days: (json['days'] as List<dynamic>).map((e) => DayCardModel.fromJson(e as Map<String, dynamic>)).toList(),
);

Map<String, dynamic> _$MonthReportModelToJson(MonthReportModel instance) => <String, dynamic>{
  'year': instance.year,
  'month': instance.month,
  'monthShort': _$MonthShortEnumMap[instance.monthShort]!,
  'summary': instance.summary,
  'days': instance.days,
};

const _$MonthShortEnumMap = {
  MonthShort.jan: 'JAN',
  MonthShort.feb: 'FEB',
  MonthShort.mar: 'MAR',
  MonthShort.apr: 'APR',
  MonthShort.may: 'MAY',
  MonthShort.jun: 'JUN',
  MonthShort.jul: 'JUL',
  MonthShort.aug: 'AUG',
  MonthShort.sep: 'SEP',
  MonthShort.oct: 'OCT',
  MonthShort.nov: 'NOV',
  MonthShort.dec: 'DEC',
};
