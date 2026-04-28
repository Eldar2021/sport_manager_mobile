// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'venue_form_param.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VenueFormParam _$VenueFormParamFromJson(Map<String, dynamic> json) => VenueFormParam(
  name: json['name'] as String,
  number: (json['number'] as num).toInt(),
  address: json['address'] as String?,
);

Map<String, dynamic> _$VenueFormParamToJson(VenueFormParam instance) => <String, dynamic>{
  'name': instance.name,
  'number': instance.number,
  'address': ?instance.address,
};
