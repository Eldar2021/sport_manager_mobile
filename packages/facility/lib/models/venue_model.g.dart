// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'venue_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VenueModel _$VenueModelFromJson(Map<String, dynamic> json) => VenueModel(
  id: json['id'] as String,
  name: json['name'] as String,
  number: (json['number'] as num).toInt(),
  type: $enumDecode(_$VenueTypeEnumMap, json['type']),
  selected: json['selected'] as bool,
  spotCount: (json['spotCount'] as num).toInt(),
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
  address: json['address'] as String?,
);

Map<String, dynamic> _$VenueModelToJson(VenueModel instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'number': instance.number,
  'type': _$VenueTypeEnumMap[instance.type]!,
  'address': instance.address,
  'selected': instance.selected,
  'spotCount': instance.spotCount,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
};

const _$VenueTypeEnumMap = {
  VenueType.tableTennis: 'TABLE_TENNIS',
  VenueType.billiards: 'BILLIARDS',
  VenueType.playStation: 'PLAY_STATION',
  VenueType.volleyball: 'VOLLEYBALL',
  VenueType.basketball: 'BASKETBALL',
  VenueType.chess: 'CHESS',
  VenueType.football: 'FOOTBALL',
};
