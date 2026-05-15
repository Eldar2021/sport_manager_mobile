import 'package:auth/models/profile_data_model.dart';
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
    this.profileData,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return _$ProfileModelFromJson(json);
  }

  final UserModel user;
  final ProfileDataModel? profileData;

  Map<String, dynamic> toJson() {
    return _$ProfileModelToJson(this);
  }

  @override
  List<Object?> get props => [
    user,
    profileData,
  ];
}
