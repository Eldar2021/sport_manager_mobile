// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription_detail_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubscriptionDetailModel _$SubscriptionDetailModelFromJson(
  Map<String, dynamic> json,
) => SubscriptionDetailModel(
  subscription: SubscriptionModel.fromJson(
    json['subscription'] as Map<String, dynamic>,
  ),
  payments: (json['payments'] as List<dynamic>).map((e) => PaymentModel.fromJson(e as Map<String, dynamic>)).toList(),
);

Map<String, dynamic> _$SubscriptionDetailModelToJson(
  SubscriptionDetailModel instance,
) => <String, dynamic>{
  'subscription': instance.subscription,
  'payments': instance.payments,
};
