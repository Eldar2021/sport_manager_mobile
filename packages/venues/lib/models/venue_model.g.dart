// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'venue_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VenueModel _$VenueModelFromJson(Map<String, dynamic> json) => VenueModel(
  id: json['id'] as String,
  ownerId: json['ownerId'] as String,
  name: json['name'] as String,
  number: json['number'] as String,
  isActive: json['isActive'] as bool,
  address: json['address'] as String?,
);

Map<String, dynamic> _$VenueModelToJson(VenueModel instance) => <String, dynamic>{
  'id': instance.id,
  'ownerId': instance.ownerId,
  'name': instance.name,
  'number': instance.number,
  'isActive': instance.isActive,
  'address': instance.address,
};
