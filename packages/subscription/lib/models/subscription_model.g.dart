// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubscriptionModel _$SubscriptionModelFromJson(Map<String, dynamic> json) => SubscriptionModel(
  id: json['id'] as String,
  ownerId: json['ownerId'] as String,
  status: $enumDecode(_$SubscriptionStatusEnumMap, json['status']),
  source: $enumDecode(_$SubscriptionSourceEnumMap, json['source']),
  startDate: DateTime.parse(json['startDate'] as String),
  endDate: DateTime.parse(json['endDate'] as String),
  daysUntilExpiry: (json['daysUntilExpiry'] as num).toInt(),
  graceDaysRemaining: (json['graceDaysRemaining'] as num).toInt(),
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
  gracePeriodEndsAt: json['gracePeriodEndsAt'] == null ? null : DateTime.parse(json['gracePeriodEndsAt'] as String),
);

Map<String, dynamic> _$SubscriptionModelToJson(SubscriptionModel instance) => <String, dynamic>{
  'id': instance.id,
  'ownerId': instance.ownerId,
  'status': _$SubscriptionStatusEnumMap[instance.status]!,
  'source': _$SubscriptionSourceEnumMap[instance.source]!,
  'startDate': instance.startDate.toIso8601String(),
  'endDate': instance.endDate.toIso8601String(),
  'gracePeriodEndsAt': instance.gracePeriodEndsAt?.toIso8601String(),
  'daysUntilExpiry': instance.daysUntilExpiry,
  'graceDaysRemaining': instance.graceDaysRemaining,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
};

const _$SubscriptionStatusEnumMap = {
  SubscriptionStatus.active: 'ACTIVE',
  SubscriptionStatus.grace: 'GRACE',
  SubscriptionStatus.expired: 'EXPIRED',
};

const _$SubscriptionSourceEnumMap = {
  SubscriptionSource.trial: 'TRIAL',
  SubscriptionSource.paid: 'PAID',
};
