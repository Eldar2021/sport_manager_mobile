// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_manager_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RegisterManagerBody _$RegisterManagerBodyFromJson(Map<String, dynamic> json) => RegisterManagerBody(
  inviteCode: json['invite_code'] as String,
  username: json['username'] as String,
  name: json['name'] as String,
  password: json['password'] as String,
);

Map<String, dynamic> _$RegisterManagerBodyToJson(
  RegisterManagerBody instance,
) => <String, dynamic>{
  'invite_code': instance.inviteCode,
  'username': instance.username,
  'name': instance.name,
  'password': instance.password,
};
