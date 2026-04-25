// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_table_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateTableBody _$UpdateTableBodyFromJson(Map<String, dynamic> json) => UpdateTableBody(
  number: json['number'] as String?,
  name: json['name'] as String?,
  hourlyRate: (json['hourlyRate'] as num?)?.toInt(),
);

Map<String, dynamic> _$UpdateTableBodyToJson(UpdateTableBody instance) => <String, dynamic>{
  'number': ?instance.number,
  'name': ?instance.name,
  'hourlyRate': ?instance.hourlyRate,
};
