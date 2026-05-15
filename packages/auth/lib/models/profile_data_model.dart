import 'package:auth/models/profile_subscription_model.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'profile_data_model.g.dart';

@immutable
@JsonSerializable()
final class ProfileDataModel extends Equatable {
  const ProfileDataModel({
    required this.venuesCount,
    required this.managersCount,
    required this.subscription,
  });

  factory ProfileDataModel.fromJson(Map<String, dynamic> json) {
    return _$ProfileDataModelFromJson(json);
  }

  final int venuesCount;
  final int managersCount;
  final ProfileSubscriptionModel subscription;

  Map<String, dynamic> toJson() {
    return _$ProfileDataModelToJson(this);
  }

  @override
  List<Object?> get props => [
    venuesCount,
    managersCount,
    subscription,
  ];
}
