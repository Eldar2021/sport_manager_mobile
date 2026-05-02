// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'insight_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InsightModel _$InsightModelFromJson(Map<String, dynamic> json) => InsightModel(
  id: json['id'] as String,
  severity: $enumDecode(_$InsightSeverityEnumMap, json['severity']),
  title: Map<String, String>.from(json['title'] as Map),
  body: Map<String, String>.from(json['body'] as Map),
  createdAt: DateTime.parse(json['createdAt'] as String),
  acknowledged: json['acknowledged'] as bool,
  action: json['action'] == null ? null : InsightAction.fromJson(json['action'] as Map<String, dynamic>),
);

Map<String, dynamic> _$InsightModelToJson(InsightModel instance) => <String, dynamic>{
  'id': instance.id,
  'severity': _$InsightSeverityEnumMap[instance.severity]!,
  'title': instance.title,
  'body': instance.body,
  'createdAt': instance.createdAt.toIso8601String(),
  'acknowledged': instance.acknowledged,
  'action': instance.action,
};

const _$InsightSeverityEnumMap = {
  InsightSeverity.info: 'INFO',
  InsightSeverity.warning: 'WARNING',
  InsightSeverity.critical: 'CRITICAL',
};
