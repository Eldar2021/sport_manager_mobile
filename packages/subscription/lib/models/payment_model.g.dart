// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentModel _$PaymentModelFromJson(Map<String, dynamic> json) => PaymentModel(
  id: json['id'] as String,
  subscriptionId: json['subscriptionId'] as String,
  amount: (json['amount'] as num).toInt(),
  currency: json['currency'] as String,
  months: (json['months'] as num).toInt(),
  tableCountSnapshot: (json['tableCountSnapshot'] as num).toInt(),
  pricePerTableSnapshot: (json['pricePerTableSnapshot'] as num).toInt(),
  status: $enumDecode(_$PaymentStatusEnumMap, json['status']),
  provider: json['provider'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
  paymentUrl: json['paymentUrl'] as String?,
  providerPaymentId: json['providerPaymentId'] as String?,
  paidAt: json['paidAt'] == null ? null : DateTime.parse(json['paidAt'] as String),
  failedAt: json['failedAt'] == null ? null : DateTime.parse(json['failedAt'] as String),
  failureReason: json['failureReason'] as String?,
);

Map<String, dynamic> _$PaymentModelToJson(PaymentModel instance) => <String, dynamic>{
  'id': instance.id,
  'subscriptionId': instance.subscriptionId,
  'amount': instance.amount,
  'currency': instance.currency,
  'months': instance.months,
  'tableCountSnapshot': instance.tableCountSnapshot,
  'pricePerTableSnapshot': instance.pricePerTableSnapshot,
  'status': _$PaymentStatusEnumMap[instance.status]!,
  'paymentUrl': instance.paymentUrl,
  'provider': instance.provider,
  'providerPaymentId': instance.providerPaymentId,
  'createdAt': instance.createdAt.toIso8601String(),
  'paidAt': instance.paidAt?.toIso8601String(),
  'failedAt': instance.failedAt?.toIso8601String(),
  'failureReason': instance.failureReason,
};

const _$PaymentStatusEnumMap = {
  PaymentStatus.pending: 'PENDING',
  PaymentStatus.paid: 'PAID',
  PaymentStatus.failed: 'FAILED',
};
