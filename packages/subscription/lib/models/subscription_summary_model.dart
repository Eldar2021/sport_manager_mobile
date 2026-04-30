import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:subscription/models/subscription_alert.dart';
import 'package:subscription/models/subscription_status.dart';

part 'subscription_summary_model.g.dart';

@immutable
@JsonSerializable()
final class SubscriptionSummaryModel extends Equatable {
  const SubscriptionSummaryModel({
    required this.status,
    required this.endDate,
    required this.daysUntilExpiry,
    required this.graceDaysRemaining,
  });

  factory SubscriptionSummaryModel.fromJson(Map<String, dynamic> json) {
    return _$SubscriptionSummaryModelFromJson(json);
  }

  final SubscriptionStatus status;
  final DateTime endDate;
  final int daysUntilExpiry;
  final int graceDaysRemaining;

  Map<String, dynamic> toJson() => _$SubscriptionSummaryModelToJson(this);

  bool get needsRenewal => alert != SubscriptionAlert.none;

  bool get isBlocked => alert == SubscriptionAlert.expired;

  SubscriptionAlert get alert {
    if (status == SubscriptionStatus.expired) return SubscriptionAlert.expired;
    if (status == SubscriptionStatus.grace) {
      return graceDaysRemaining <= 0 ? SubscriptionAlert.expired : SubscriptionAlert.grace;
    }
    if (daysUntilExpiry <= 3) return SubscriptionAlert.warning;
    return SubscriptionAlert.none;
  }

  @override
  List<Object?> get props => [status, endDate, daysUntilExpiry, graceDaysRemaining];
}
