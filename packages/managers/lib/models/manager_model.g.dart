// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'manager_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ManagerModel _$ManagerModelFromJson(Map<String, dynamic> json) => ManagerModel(
  id: json['id'] as String,
  name: json['name'] as String,
  username: json['username'] as String,
  lastSeenAt: json['lastSeenAt'] == null ? null : DateTime.parse(json['lastSeenAt'] as String),
);

Map<String, dynamic> _$ManagerModelToJson(ManagerModel instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'username': instance.username,
  'lastSeenAt': instance.lastSeenAt?.toIso8601String(),
};
