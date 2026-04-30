// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription_summary_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubscriptionSummaryModel _$SubscriptionSummaryModelFromJson(
  Map<String, dynamic> json,
) => SubscriptionSummaryModel(
  status: $enumDecode(_$SubscriptionStatusEnumMap, json['status']),
  endDate: DateTime.parse(json['endDate'] as String),
  daysUntilExpiry: (json['daysUntilExpiry'] as num).toInt(),
  graceDaysRemaining: (json['graceDaysRemaining'] as num).toInt(),
);

Map<String, dynamic> _$SubscriptionSummaryModelToJson(
  SubscriptionSummaryModel instance,
) => <String, dynamic>{
  'status': _$SubscriptionStatusEnumMap[instance.status]!,
  'endDate': instance.endDate.toIso8601String(),
  'daysUntilExpiry': instance.daysUntilExpiry,
  'graceDaysRemaining': instance.graceDaysRemaining,
};

const _$SubscriptionStatusEnumMap = {
  SubscriptionStatus.active: 'ACTIVE',
  SubscriptionStatus.grace: 'GRACE',
  SubscriptionStatus.expired: 'EXPIRED',
};
