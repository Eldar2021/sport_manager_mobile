import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
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
