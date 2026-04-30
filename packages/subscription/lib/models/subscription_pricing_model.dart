import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'subscription_pricing_model.g.dart';

@immutable
@JsonSerializable()
final class SubscriptionPricingModel extends Equatable {
  const SubscriptionPricingModel({
    required this.pricePerTable,
    required this.currency,
    required this.tableCount,
    required this.monthlyAmount,
    required this.minDurationMonths,
    required this.maxDurationMonths,
    required this.gracePeriodDays,
    required this.freeTrialDays,
    required this.expiryWarningDays,
  });

  factory SubscriptionPricingModel.fromJson(Map<String, dynamic> json) {
    return _$SubscriptionPricingModelFromJson(json);
  }

  final int pricePerTable;
  final String currency;
  final int tableCount;
  final int monthlyAmount;
  final int minDurationMonths;
  final int maxDurationMonths;
  final int gracePeriodDays;
  final int freeTrialDays;
  final int expiryWarningDays;

  Map<String, dynamic> toJson() => _$SubscriptionPricingModelToJson(this);

  int totalAmountFor(int months) => pricePerTable * tableCount * months;

  @override
  List<Object?> get props => [
    pricePerTable,
    currency,
    tableCount,
    monthlyAmount,
    minDurationMonths,
    maxDurationMonths,
    gracePeriodDays,
    freeTrialDays,
    expiryWarningDays,
  ];
}
