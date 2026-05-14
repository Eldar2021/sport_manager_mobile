// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_subscription_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProfileSubscriptionModel _$ProfileSubscriptionModelFromJson(
  Map<String, dynamic> json,
) => ProfileSubscriptionModel(
  endDate: DateTime.parse(json['endDate'] as String),
  status: json['status'] as String,
  daysUntilExpiry: (json['daysUntilExpiry'] as num).toInt(),
  graceDaysRemaining: (json['graceDaysRemaining'] as num).toInt(),
);

Map<String, dynamic> _$ProfileSubscriptionModelToJson(
  ProfileSubscriptionModel instance,
) => <String, dynamic>{
  'endDate': instance.endDate.toIso8601String(),
  'status': instance.status,
  'daysUntilExpiry': instance.daysUntilExpiry,
  'graceDaysRemaining': instance.graceDaysRemaining,
};
