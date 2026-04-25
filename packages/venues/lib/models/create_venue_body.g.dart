// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_venue_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateVenueBody _$CreateVenueBodyFromJson(Map<String, dynamic> json) => CreateVenueBody(
  name: json['name'] as String,
  number: json['number'] as String,
  address: json['address'] as String?,
);

Map<String, dynamic> _$CreateVenueBodyToJson(CreateVenueBody instance) => <String, dynamic>{
  'name': instance.name,
  'number': instance.number,
  'address': ?instance.address,
};
