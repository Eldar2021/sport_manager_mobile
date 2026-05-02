// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'manager_session_log_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ManagerSessionLogEntry _$ManagerSessionLogEntryFromJson(
  Map<String, dynamic> json,
) => ManagerSessionLogEntry(
  sessionId: json['sessionId'] as String,
  tableId: json['tableId'] as String,
  tableNumber: (json['tableNumber'] as num).toInt(),
  venueName: json['venueName'] as String,
  startedAt: DateTime.parse(json['startedAt'] as String),
  endedAt: DateTime.parse(json['endedAt'] as String),
  status: $enumDecode(_$ManagerSessionLogStatusEnumMap, json['status']),
  currency: $enumDecode(_$CurrencyEnumMap, json['currency']),
  tableName: json['tableName'] as String?,
  durationSeconds: (json['durationSeconds'] as num?)?.toInt(),
  totalAmount: (json['totalAmount'] as num?)?.toInt(),
  discountPercent: (json['discountPercent'] as num?)?.toInt(),
  cancelReason: json['cancelReason'] as String?,
);

Map<String, dynamic> _$ManagerSessionLogEntryToJson(
  ManagerSessionLogEntry instance,
) => <String, dynamic>{
  'sessionId': instance.sessionId,
  'tableId': instance.tableId,
  'tableNumber': instance.tableNumber,
  'tableName': instance.tableName,
  'venueName': instance.venueName,
  'startedAt': instance.startedAt.toIso8601String(),
  'endedAt': instance.endedAt.toIso8601String(),
  'status': _$ManagerSessionLogStatusEnumMap[instance.status]!,
  'currency': _$CurrencyEnumMap[instance.currency]!,
  'durationSeconds': instance.durationSeconds,
  'totalAmount': instance.totalAmount,
  'discountPercent': instance.discountPercent,
  'cancelReason': instance.cancelReason,
};

const _$ManagerSessionLogStatusEnumMap = {
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
