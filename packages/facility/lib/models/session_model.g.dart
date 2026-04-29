// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SessionModel _$SessionModelFromJson(Map<String, dynamic> json) => SessionModel(
  id: json['id'] as String,
  tableId: json['tableId'] as String,
  status: $enumDecode(_$SessionStatusEnumMap, json['status']),
  startedAt: DateTime.parse(json['startedAt'] as String),
  totalPausedSeconds: (json['totalPausedSeconds'] as num).toInt(),
  tarifAmountSnapshot: (json['tarifAmountSnapshot'] as num).toInt(),
  tarifTypeSnapshot: $enumDecode(_$TarifTypeEnumMap, json['tarifTypeSnapshot']),
  pausedAt: json['pausedAt'] == null ? null : DateTime.parse(json['pausedAt'] as String),
);

Map<String, dynamic> _$SessionModelToJson(SessionModel instance) => <String, dynamic>{
  'id': instance.id,
  'tableId': instance.tableId,
  'status': _$SessionStatusEnumMap[instance.status]!,
  'startedAt': instance.startedAt.toIso8601String(),
  'pausedAt': instance.pausedAt?.toIso8601String(),
  'totalPausedSeconds': instance.totalPausedSeconds,
  'tarifAmountSnapshot': instance.tarifAmountSnapshot,
  'tarifTypeSnapshot': _$TarifTypeEnumMap[instance.tarifTypeSnapshot]!,
};

const _$SessionStatusEnumMap = {
  SessionStatus.active: 'ACTIVE',
  SessionStatus.paused: 'PAUSED',
};

const _$TarifTypeEnumMap = {
  TarifType.minute: 'MINUTE',
  TarifType.hour: 'HOUR',
  TarifType.day: 'DAY',
};
