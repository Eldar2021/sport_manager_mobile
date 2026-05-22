// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'manager_session_log_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ManagerSessionLogEntry _$ManagerSessionLogEntryFromJson(
  Map<String, dynamic> json,
) => ManagerSessionLogEntry(
  sessionId: json['sessionId'] as String,
  spotId: json['spotId'] as String,
  spotNumber: (json['spotNumber'] as num).toInt(),
  venueName: json['venueName'] as String,
  startedAt: DateTime.parse(json['startedAt'] as String),
  status: $enumDecode(_$ManagerSessionLogStatusEnumMap, json['status']),
  currency: $enumDecode(_$CurrencyEnumMap, json['currency']),
  customerName: json['customerName'] as String?,
  endedAt: json['endedAt'] == null ? null : DateTime.parse(json['endedAt'] as String),
  spotName: json['spotName'] as String?,
  durationSeconds: (json['durationSeconds'] as num?)?.toInt(),
  totalAmount: (json['totalAmount'] as num?)?.toInt(),
  cancelReason: json['cancelReason'] as String?,
);

Map<String, dynamic> _$ManagerSessionLogEntryToJson(
  ManagerSessionLogEntry instance,
) => <String, dynamic>{
  'sessionId': instance.sessionId,
  'spotId': instance.spotId,
  'spotNumber': instance.spotNumber,
  'spotName': instance.spotName,
  'venueName': instance.venueName,
  'customerName': instance.customerName,
  'startedAt': instance.startedAt.toIso8601String(),
  'endedAt': instance.endedAt?.toIso8601String(),
  'status': _$ManagerSessionLogStatusEnumMap[instance.status]!,
  'currency': _$CurrencyEnumMap[instance.currency]!,
  'durationSeconds': instance.durationSeconds,
  'totalAmount': instance.totalAmount,
  'cancelReason': instance.cancelReason,
};

const _$ManagerSessionLogStatusEnumMap = {
  ManagerSessionLogStatus.active: 'ACTIVE',
  ManagerSessionLogStatus.completed: 'COMPLETED',
  ManagerSessionLogStatus.cancelled: 'CANCELLED',
};

const _$CurrencyEnumMap = {
  Currency.kgs: 'KGS',
  Currency.usd: 'USD',
  Currency.rub: 'RUB',
  Currency.kzt: 'KZT',
  Currency.tryLira: 'TRY',
};
