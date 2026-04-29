import 'package:auth/models/user_role.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'user_model.g.dart';

@immutable
@JsonSerializable()
final class UserModel extends Equatable {
  const UserModel({
    required this.id,
    required this.name,
    required this.role,
    this.email,
    this.phone,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return _$UserModelFromJson(json);
  }

  final String id;
  final String name;
  final UserRole role;
  final String? email;
  final String? phone;

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  @override
  List<Object?> get props => [
    id,
    name,
    role,
    email,
    phone,
  ];

  String get avatarChar {
    final nameParts = name.split(' ');
    if (nameParts.length > 1) {
      return '${nameParts.first[0]} ${nameParts.last[0]}'.toUpperCase();
    }
    return name[0].toUpperCase();
  }
}
