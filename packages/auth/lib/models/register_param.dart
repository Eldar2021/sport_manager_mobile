import 'package:auth/auth.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'register_param.g.dart';

sealed class RegisterParam extends Equatable {
  const RegisterParam({
    required this.name,
    required this.password,
    required this.email,
    required this.phone,
    required this.role,
  });

  final String name;
  final String email;
  final String phone;
  final String password;
  final UserRole role;
}

@immutable
@JsonSerializable()
final class RegisterOwnerParam extends RegisterParam {
  const RegisterOwnerParam({
    required super.name,
    required super.phone,
    required super.email,
    required super.password,
    super.role = UserRole.owner,
  });

  factory RegisterOwnerParam.fromJson(Map<String, dynamic> json) {
    return _$RegisterOwnerParamFromJson(json);
  }

  Map<String, dynamic> toJson() => _$RegisterOwnerParamToJson(this);

  @override
  List<Object?> get props => [
    name,
    phone,
    email,
    password,
    role,
  ];
}

@immutable
@JsonSerializable()
final class RegisterManagerParam extends RegisterParam {
  const RegisterManagerParam({
    required this.inviteCode,
    required super.name,
    required super.password,
    required super.email,
    required super.phone,
    super.role = UserRole.manager,
  });

  factory RegisterManagerParam.fromJson(Map<String, dynamic> json) {
    return _$RegisterManagerParamFromJson(json);
  }

  final String inviteCode;

  Map<String, dynamic> toJson() => _$RegisterManagerParamToJson(this);

  @override
  List<Object?> get props => [
    inviteCode,
    name,
    phone,
    email,
    password,
    role,
  ];
}
