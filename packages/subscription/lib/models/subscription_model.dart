import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:subscription/models/subscription_alert.dart';
import 'package:subscription/models/subscription_source.dart';
import 'package:subscription/models/subscription_status.dart';

part 'subscription_model.g.dart';

@immutable
@JsonSerializable()
final class SubscriptionModel extends Equatable {
  const SubscriptionModel({
    required this.id,
    required this.ownerId,
    required this.status,
    required this.source,
    required this.startDate,
    required this.endDate,
    required this.daysUntilExpiry,
    required this.graceDaysRemaining,
    required this.createdAt,
    required this.updatedAt,
    this.gracePeriodEndsAt,
  });

  factory SubscriptionModel.fromJson(Map<String, dynamic> json) {
    return _$SubscriptionModelFromJson(json);
  }

  final String id;
  final String ownerId;
  final SubscriptionStatus status;
  final SubscriptionSource source;
  final DateTime startDate;
  final DateTime endDate;
  final DateTime? gracePeriodEndsAt;
  final int daysUntilExpiry;
  final int graceDaysRemaining;
  final DateTime createdAt;
  final DateTime updatedAt;

  Map<String, dynamic> toJson() => _$SubscriptionModelToJson(this);

  /// True when the UI should surface a renewal CTA (warning, grace, or expired).
  bool get needsRenewal => alert != SubscriptionAlert.none;

  /// Hard-blocked: status is `EXPIRED` or grace ran out.
  bool get isBlocked => alert == SubscriptionAlert.expired;

  /// Single derived alert kind for UI banners / badges / FABs.
  SubscriptionAlert get alert {
    if (status == SubscriptionStatus.expired) return SubscriptionAlert.expired;
    if (status == SubscriptionStatus.grace) {
      return graceDaysRemaining <= 0 ? SubscriptionAlert.expired : SubscriptionAlert.grace;
    }
    if (daysUntilExpiry <= 3) return SubscriptionAlert.warning;
    return SubscriptionAlert.none;
  }

  @override
  List<Object?> get props => [
    id,
    ownerId,
    status,
    source,
    startDate,
    endDate,
    gracePeriodEndsAt,
    daysUntilExpiry,
    graceDaysRemaining,
    createdAt,
    updatedAt,
  ];
}
