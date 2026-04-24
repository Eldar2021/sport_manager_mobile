import 'package:auth/auth.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'user_model.g.dart';

@immutable
@JsonSerializable()
final class UserModel extends Equatable {
  const UserModel({
    required this.id,
    required this.username,
    required this.name,
    required this.role,
    this.email,
    this.phone,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);

  final String id;
  final String username;
  final String name;
  final UserRole role;
  final String? email;
  final String? phone;

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  @override
  List<Object?> get props => [id, username, name, role, email, phone];
}
