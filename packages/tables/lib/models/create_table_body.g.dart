// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_table_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateTableBody _$CreateTableBodyFromJson(Map<String, dynamic> json) => CreateTableBody(
  number: json['number'] as String,
  hourlyRate: (json['hourlyRate'] as num).toInt(),
  name: json['name'] as String?,
);

Map<String, dynamic> _$CreateTableBodyToJson(CreateTableBody instance) => <String, dynamic>{
  'number': instance.number,
  'name': ?instance.name,
  'hourlyRate': instance.hourlyRate,
};
