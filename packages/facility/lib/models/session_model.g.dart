// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SessionModel _$SessionModelFromJson(Map<String, dynamic> json) => SessionModel(
  id: json['id'] as String,
  spotId: json['spotId'] as String,
  status: $enumDecode(_$SessionStatusEnumMap, json['status']),
  startedAt: DateTime.parse(json['startedAt'] as String),
  totalPausedSeconds: (json['totalPausedSeconds'] as num?)?.toInt() ?? 0,
  pausedAt: json['pausedAt'] == null ? null : DateTime.parse(json['pausedAt'] as String),
  tarifAmountSnapshot: (json['tarifAmountSnapshot'] as num?)?.toInt(),
  tarifTypeSnapshot: $enumDecodeNullable(
    _$TarifTypeEnumMap,
    json['tarifTypeSnapshot'],
  ),
  endedAt: json['endedAt'] == null ? null : DateTime.parse(json['endedAt'] as String),
  durationSeconds: (json['durationSeconds'] as num?)?.toInt(),
  subtotal: (json['subtotal'] as num?)?.toInt(),
  discountPercent: (json['discountPercent'] as num?)?.toInt(),
  totalAmount: (json['totalAmount'] as num?)?.toInt(),
  cancelReason: json['cancelReason'] as String?,
  customerName: json['customerName'] as String?,
);

Map<String, dynamic> _$SessionModelToJson(SessionModel instance) => <String, dynamic>{
  'id': instance.id,
  'spotId': instance.spotId,
  'status': _$SessionStatusEnumMap[instance.status]!,
  'startedAt': instance.startedAt.toIso8601String(),
  'customerName': instance.customerName,
  'totalPausedSeconds': instance.totalPausedSeconds,
  'pausedAt': instance.pausedAt?.toIso8601String(),
  'tarifAmountSnapshot': instance.tarifAmountSnapshot,
  'tarifTypeSnapshot': _$TarifTypeEnumMap[instance.tarifTypeSnapshot],
  'endedAt': instance.endedAt?.toIso8601String(),
  'durationSeconds': instance.durationSeconds,
  'subtotal': instance.subtotal,
  'discountPercent': instance.discountPercent,
  'totalAmount': instance.totalAmount,
  'cancelReason': instance.cancelReason,
};

const _$SessionStatusEnumMap = {
  SessionStatus.active: 'ACTIVE',
  SessionStatus.paused: 'PAUSED',
  SessionStatus.cancelled: 'CANCELLED',
  SessionStatus.completed: 'COMPLETED',
};

const _$TarifTypeEnumMap = {
  TarifType.minute: 'MINUTE',
  TarifType.hour: 'HOUR',
  TarifType.day: 'DAY',
};
