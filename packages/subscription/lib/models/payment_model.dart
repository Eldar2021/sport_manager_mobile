import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:subscription/models/payment_status.dart';

part 'payment_model.g.dart';

@immutable
@JsonSerializable()
final class PaymentModel extends Equatable {
  const PaymentModel({
    required this.id,
    required this.subscriptionId,
    required this.amount,
    required this.currency,
    required this.months,
    required this.spotCountSnapshot,
    required this.pricePerSpotSnapshot,
    required this.status,
    required this.provider,
    required this.createdAt,
    this.paymentUrl,
    this.providerPaymentId,
    this.paidAt,
    this.failedAt,
    this.failureReason,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return _$PaymentModelFromJson(json);
  }

  final String id;
  final String subscriptionId;
  final int amount;
  final String currency;
  final int months;
  final int spotCountSnapshot;
  final int? pricePerSpotSnapshot;
  final PaymentStatus status;
  final String? paymentUrl;
  final String provider;
  final String? providerPaymentId;
  final DateTime createdAt;
  final DateTime? paidAt;
  final DateTime? failedAt;
  final String? failureReason;

  Map<String, dynamic> toJson() => _$PaymentModelToJson(this);

  bool get isMock => provider.toUpperCase() == 'MOCK';

  @override
  List<Object?> get props => [
    id,
    subscriptionId,
    amount,
    currency,
    months,
    spotCountSnapshot,
    pricePerSpotSnapshot,
    status,
    paymentUrl,
    provider,
    providerPaymentId,
    createdAt,
    paidAt,
    failedAt,
    failureReason,
  ];
}
