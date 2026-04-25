// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SessionModel _$SessionModelFromJson(Map<String, dynamic> json) => SessionModel(
  id: json['id'] as String,
  tableId: json['tableId'] as String,
  venueId: json['venueId'] as String,
  managerId: json['managerId'] as String,
  startedAt: DateTime.parse(json['startedAt'] as String),
  hourlyRateSnapshot: (json['hourlyRateSnapshot'] as num).toInt(),
  discountPercent: (json['discountPercent'] as num).toInt(),
  status: $enumDecode(_$SessionStatusEnumMap, json['status']),
  endedAt: json['endedAt'] == null ? null : DateTime.parse(json['endedAt'] as String),
  durationSeconds: (json['durationSeconds'] as num?)?.toInt(),
  subtotal: (json['subtotal'] as num?)?.toInt(),
  totalAmount: (json['totalAmount'] as num?)?.toInt(),
  notes: json['notes'] as String?,
);

Map<String, dynamic> _$SessionModelToJson(SessionModel instance) => <String, dynamic>{
  'id': instance.id,
  'tableId': instance.tableId,
  'venueId': instance.venueId,
  'managerId': instance.managerId,
  'startedAt': instance.startedAt.toIso8601String(),
  'endedAt': instance.endedAt?.toIso8601String(),
  'durationSeconds': instance.durationSeconds,
  'hourlyRateSnapshot': instance.hourlyRateSnapshot,
  'subtotal': instance.subtotal,
  'discountPercent': instance.discountPercent,
  'totalAmount': instance.totalAmount,
  'status': _$SessionStatusEnumMap[instance.status]!,
  'notes': instance.notes,
};

const _$SessionStatusEnumMap = {
  SessionStatus.active: 'ACTIVE',
  SessionStatus.completed: 'COMPLETED',
  SessionStatus.cancelled: 'CANCELLED',
};
