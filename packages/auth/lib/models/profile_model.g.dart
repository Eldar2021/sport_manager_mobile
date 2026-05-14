// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProfileModel _$ProfileModelFromJson(Map<String, dynamic> json) => ProfileModel(
  user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
  profileData: json['profileData'] == null
      ? null
      : ProfileDataModel.fromJson(json['profileData'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ProfileModelToJson(ProfileModel instance) => <String, dynamic>{
  'user': instance.user,
  'profileData': instance.profileData,
};
