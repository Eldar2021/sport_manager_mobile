// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'day_report_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DayReportModel _$DayReportModelFromJson(Map<String, dynamic> json) => DayReportModel(
  date: DateTime.parse(json['date'] as String),
  dayOfWeek: $enumDecode(_$DayOfWeekEnumMap, json['dayOfWeek']),
  summary: ReportSummaryModel.fromJson(
    json['summary'] as Map<String, dynamic>,
  ),
  sessions: (json['sessions'] as List<dynamic>)
      .map((e) => SessionCardModel.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$DayReportModelToJson(DayReportModel instance) => <String, dynamic>{
  'date': instance.date.toIso8601String(),
  'dayOfWeek': _$DayOfWeekEnumMap[instance.dayOfWeek]!,
  'summary': instance.summary,
  'sessions': instance.sessions,
};

const _$DayOfWeekEnumMap = {
  DayOfWeek.monday: 'MONDAY',
  DayOfWeek.tuesday: 'TUESDAY',
  DayOfWeek.wednesday: 'WEDNESDAY',
  DayOfWeek.thursday: 'THURSDAY',
  DayOfWeek.friday: 'FRIDAY',
  DayOfWeek.saturday: 'SATURDAY',
  DayOfWeek.sunday: 'SUNDAY',
};
