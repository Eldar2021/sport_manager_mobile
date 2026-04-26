// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_param.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RegisterOwnerParam _$RegisterOwnerParamFromJson(
  Map<String, dynamic> json,
) => RegisterOwnerParam(
  name: json['name'] as String,
  phone: json['phone'] as String,
  email: json['email'] as String,
  password: json['password'] as String,
  role: $enumDecodeNullable(_$UserRoleEnumMap, json['role']) ?? UserRole.owner,
);

Map<String, dynamic> _$RegisterOwnerParamToJson(RegisterOwnerParam instance) => <String, dynamic>{
  'name': instance.name,
  'email': instance.email,
  'phone': instance.phone,
  'password': instance.password,
  'role': _$UserRoleEnumMap[instance.role]!,
};

const _$UserRoleEnumMap = {
  UserRole.owner: 'OWNER',
  UserRole.manager: 'MANAGER',
};

RegisterManagerParam _$RegisterManagerParamFromJson(
  Map<String, dynamic> json,
) => RegisterManagerParam(
  inviteCode: json['inviteCode'] as String,
  name: json['name'] as String,
  password: json['password'] as String,
  email: json['email'] as String,
  phone: json['phone'] as String,
  role: $enumDecodeNullable(_$UserRoleEnumMap, json['role']) ?? UserRole.manager,
);

Map<String, dynamic> _$RegisterManagerParamToJson(
  RegisterManagerParam instance,
) => <String, dynamic>{
  'name': instance.name,
  'email': instance.email,
  'phone': instance.phone,
  'password': instance.password,
  'role': _$UserRoleEnumMap[instance.role]!,
  'inviteCode': instance.inviteCode,
};
