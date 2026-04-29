import 'package:auth/models/user_model.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'profile_model.g.dart';

@immutable
@JsonSerializable()
final class ProfileModel extends Equatable {
  const ProfileModel({
    required this.user,
    required this.venuesCount,
    required this.managersCount,
    required this.subscriptionEndDate,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return _$ProfileModelFromJson(json);
  }

  final UserModel user;
  final int venuesCount;
  final int managersCount;
  final DateTime subscriptionEndDate;

  Map<String, dynamic> toJson() => _$ProfileModelToJson(this);

  @override
  List<Object?> get props => [
    user,
    venuesCount,
    managersCount,
    subscriptionEndDate,
  ];
}
