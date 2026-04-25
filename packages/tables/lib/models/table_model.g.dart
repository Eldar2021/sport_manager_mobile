// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'table_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TableModel _$TableModelFromJson(Map<String, dynamic> json) => TableModel(
  id: json['id'] as String,
  venueId: json['venueId'] as String,
  number: json['number'] as String,
  hourlyRate: (json['hourlyRate'] as num).toInt(),
  status: $enumDecode(_$TableStatusEnumMap, json['status']),
  name: json['name'] as String?,
);

Map<String, dynamic> _$TableModelToJson(TableModel instance) => <String, dynamic>{
  'id': instance.id,
  'venueId': instance.venueId,
  'number': instance.number,
  'name': instance.name,
  'hourlyRate': instance.hourlyRate,
  'status': _$TableStatusEnumMap[instance.status]!,
};

const _$TableStatusEnumMap = {
  TableStatus.available: 'AVAILABLE',
  TableStatus.occupied: 'OCCUPIED',
};
