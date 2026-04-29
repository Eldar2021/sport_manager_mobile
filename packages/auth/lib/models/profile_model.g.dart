// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProfileModel _$ProfileModelFromJson(Map<String, dynamic> json) => ProfileModel(
  user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
  venuesCount: (json['venuesCount'] as num).toInt(),
  managersCount: (json['managersCount'] as num).toInt(),
  subscriptionEndDate: DateTime.parse(json['subscriptionEndDate'] as String),
);

Map<String, dynamic> _$ProfileModelToJson(ProfileModel instance) => <String, dynamic>{
  'user': instance.user,
  'venuesCount': instance.venuesCount,
  'managersCount': instance.managersCount,
  'subscriptionEndDate': instance.subscriptionEndDate.toIso8601String(),
};
