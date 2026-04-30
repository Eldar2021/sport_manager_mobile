// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription_pricing_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubscriptionPricingModel _$SubscriptionPricingModelFromJson(
  Map<String, dynamic> json,
) => SubscriptionPricingModel(
  pricePerTable: (json['pricePerTable'] as num).toInt(),
  currency: json['currency'] as String,
  tableCount: (json['tableCount'] as num).toInt(),
  monthlyAmount: (json['monthlyAmount'] as num).toInt(),
  minDurationMonths: (json['minDurationMonths'] as num).toInt(),
  maxDurationMonths: (json['maxDurationMonths'] as num).toInt(),
  gracePeriodDays: (json['gracePeriodDays'] as num).toInt(),
  freeTrialDays: (json['freeTrialDays'] as num).toInt(),
  expiryWarningDays: (json['expiryWarningDays'] as num).toInt(),
);

Map<String, dynamic> _$SubscriptionPricingModelToJson(
  SubscriptionPricingModel instance,
) => <String, dynamic>{
  'pricePerTable': instance.pricePerTable,
  'currency': instance.currency,
  'tableCount': instance.tableCount,
  'monthlyAmount': instance.monthlyAmount,
  'minDurationMonths': instance.minDurationMonths,
  'maxDurationMonths': instance.maxDurationMonths,
  'gracePeriodDays': instance.gracePeriodDays,
  'freeTrialDays': instance.freeTrialDays,
  'expiryWarningDays': instance.expiryWarningDays,
};
