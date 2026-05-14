import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'profile_subscription_model.g.dart';

@immutable
@JsonSerializable()
final class ProfileSubscriptionModel extends Equatable {
  const ProfileSubscriptionModel({
    required this.endDate,
    required this.status,
    required this.daysUntilExpiry,
    required this.graceDaysRemaining,
  });

  factory ProfileSubscriptionModel.fromJson(Map<String, dynamic> json) {
    return _$ProfileSubscriptionModelFromJson(json);
  }

  final DateTime endDate;
  final String status;
  final int daysUntilExpiry;
  final int graceDaysRemaining;

  Map<String, dynamic> toJson() {
    return _$ProfileSubscriptionModelToJson(this);
  }

  @override
  List<Object?> get props => [
    endDate,
    status,
    daysUntilExpiry,
    graceDaysRemaining,
  ];
}
