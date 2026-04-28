// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SessionModel _$SessionModelFromJson(Map<String, dynamic> json) => SessionModel(
  id: json['id'] as String,
  tableId: json['tableId'] as String,
  isActive: json['isActive'] as bool,
  isPaused: json['isPaused'] as bool,
  startedAt: DateTime.parse(json['startedAt'] as String),
  totalPausedSeconds: (json['totalPausedSeconds'] as num).toInt(),
  tarifAmountSnapshot: (json['tarifAmountSnapshot'] as num).toInt(),
  tarifTypeSnapshot: $enumDecode(_$TarifTypeEnumMap, json['tarifTypeSnapshot']),
  pausedAt: json['pausedAt'] == null ? null : DateTime.parse(json['pausedAt'] as String),
  resumedAt: json['resumedAt'] == null ? null : DateTime.parse(json['resumedAt'] as String),
);

Map<String, dynamic> _$SessionModelToJson(SessionModel instance) => <String, dynamic>{
  'id': instance.id,
  'tableId': instance.tableId,
  'isActive': instance.isActive,
  'isPaused': instance.isPaused,
  'startedAt': instance.startedAt.toIso8601String(),
  'pausedAt': instance.pausedAt?.toIso8601String(),
  'resumedAt': instance.resumedAt?.toIso8601String(),
  'totalPausedSeconds': instance.totalPausedSeconds,
  'tarifAmountSnapshot': instance.tarifAmountSnapshot,
  'tarifTypeSnapshot': _$TarifTypeEnumMap[instance.tarifTypeSnapshot]!,
};

const _$TarifTypeEnumMap = {
  TarifType.minute: 'MINUTE',
  TarifType.hour: 'HOUR',
  TarifType.day: 'DAY',
};
