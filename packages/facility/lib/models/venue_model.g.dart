// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'venue_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VenueModel _$VenueModelFromJson(Map<String, dynamic> json) => VenueModel(
  id: json['id'] as String,
  name: json['name'] as String,
  number: (json['number'] as num).toInt(),
  selected: json['selected'] as bool,
  tableCount: (json['tableCount'] as num).toInt(),
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
  address: json['address'] as String?,
);

Map<String, dynamic> _$VenueModelToJson(VenueModel instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'number': instance.number,
  'address': instance.address,
  'selected': instance.selected,
  'tableCount': instance.tableCount,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
};
