import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:subscription/models/payment_model.dart';
import 'package:subscription/models/subscription_model.dart';

part 'subscription_detail_model.g.dart';

@immutable
@JsonSerializable()
final class SubscriptionDetailModel extends Equatable {
  const SubscriptionDetailModel({
    required this.subscription,
    required this.payments,
  });

  factory SubscriptionDetailModel.fromJson(Map<String, dynamic> json) {
    return _$SubscriptionDetailModelFromJson(json);
  }

  final SubscriptionModel subscription;
  final List<PaymentModel> payments;

  Map<String, dynamic> toJson() => _$SubscriptionDetailModelToJson(this);

  @override
  List<Object?> get props => [subscription, payments];
}
