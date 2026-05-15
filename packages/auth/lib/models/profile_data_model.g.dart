// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_data_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProfileDataModel _$ProfileDataModelFromJson(Map<String, dynamic> json) => ProfileDataModel(
  venuesCount: (json['venuesCount'] as num).toInt(),
  managersCount: (json['managersCount'] as num).toInt(),
  subscription: ProfileSubscriptionModel.fromJson(
    json['subscription'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$ProfileDataModelToJson(ProfileDataModel instance) => <String, dynamic>{
  'venuesCount': instance.venuesCount,
  'managersCount': instance.managersCount,
  'subscription': instance.subscription,
};
