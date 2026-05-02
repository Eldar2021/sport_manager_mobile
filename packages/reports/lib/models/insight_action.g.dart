// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'insight_action.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InsightAction _$InsightActionFromJson(Map<String, dynamic> json) => InsightAction(
  type: $enumDecode(_$InsightActionTypeEnumMap, json['type']),
  targetId: json['targetId'] as String?,
);

Map<String, dynamic> _$InsightActionToJson(InsightAction instance) => <String, dynamic>{
  'type': _$InsightActionTypeEnumMap[instance.type]!,
  'targetId': instance.targetId,
};

const _$InsightActionTypeEnumMap = {
  InsightActionType.none: 'NONE',
  InsightActionType.managerDetail: 'MANAGER_DETAIL',
  InsightActionType.tableDetail: 'TABLE_DETAIL',
  InsightActionType.venueDetail: 'VENUE_DETAIL',
  InsightActionType.forecast: 'FORECAST',
};
