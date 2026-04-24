import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'register_owner_body.g.dart';

@immutable
@JsonSerializable()
final class RegisterOwnerBody extends Equatable {
  const RegisterOwnerBody({
    required this.name,
    required this.phone,
    required this.email,
    required this.password,
  });

  factory RegisterOwnerBody.fromJson(Map<String, dynamic> json) => _$RegisterOwnerBodyFromJson(json);

  final String name;
  final String phone;
  final String email;
  final String password;

  Map<String, dynamic> toJson() => _$RegisterOwnerBodyToJson(this);

  @override
  List<Object?> get props => [name, phone, email, password];
}
