// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'venue_form_param.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VenueFormParam _$VenueFormParamFromJson(Map<String, dynamic> json) => VenueFormParam(
  name: json['name'] as String,
  number: (json['number'] as num).toInt(),
  type: $enumDecode(_$VenueTypeEnumMap, json['type']),
  address: json['address'] as String?,
);

Map<String, dynamic> _$VenueFormParamToJson(VenueFormParam instance) => <String, dynamic>{
  'name': instance.name,
  'number': instance.number,
  'type': _$VenueTypeEnumMap[instance.type]!,
  'address': ?instance.address,
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
