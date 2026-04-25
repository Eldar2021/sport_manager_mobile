// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invite_code_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InviteCodeModel _$InviteCodeModelFromJson(Map<String, dynamic> json) => InviteCodeModel(
  code: json['code'] as String,
  expiresAt: json['expiresAt'] == null ? null : DateTime.parse(json['expiresAt'] as String),
);

Map<String, dynamic> _$InviteCodeModelToJson(InviteCodeModel instance) => <String, dynamic>{
  'code': instance.code,
  'expiresAt': instance.expiresAt?.toIso8601String(),
};
