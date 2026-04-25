// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_owner_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RegisterOwnerBody _$RegisterOwnerBodyFromJson(Map<String, dynamic> json) => RegisterOwnerBody(
  name: json['name'] as String,
  phone: json['phone'] as String,
  email: json['email'] as String,
  password: json['password'] as String,
  venueName: json['venueName'] as String,
  venueNumber: json['venueNumber'] as String,
);

Map<String, dynamic> _$RegisterOwnerBodyToJson(RegisterOwnerBody instance) => <String, dynamic>{
  'name': instance.name,
  'phone': instance.phone,
  'email': instance.email,
  'password': instance.password,
  'venueName': instance.venueName,
  'venueNumber': instance.venueNumber,
};
