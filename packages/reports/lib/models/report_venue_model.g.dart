// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_venue_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReportVenueModel _$ReportVenueModelFromJson(Map<String, dynamic> json) => ReportVenueModel(
  id: json['id'] as String,
  name: json['name'] as String,
  number: (json['number'] as num).toInt(),
);

Map<String, dynamic> _$ReportVenueModelToJson(ReportVenueModel instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'number': instance.number,
};
