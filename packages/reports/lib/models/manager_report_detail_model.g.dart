// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'manager_report_detail_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ManagerReportDetailModel _$ManagerReportDetailModelFromJson(
  Map<String, dynamic> json,
) => ManagerReportDetailModel(
  summary: ManagerReportRowModel.fromJson(
    json['summary'] as Map<String, dynamic>,
  ),
  sessionLog: (json['sessionLog'] as List<dynamic>)
      .map((e) => ManagerSessionLogEntry.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$ManagerReportDetailModelToJson(
  ManagerReportDetailModel instance,
) => <String, dynamic>{
  'summary': instance.summary,
  'sessionLog': instance.sessionLog,
};
