import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'register_manager_body.g.dart';

@immutable
@JsonSerializable()
final class RegisterManagerBody extends Equatable {
  const RegisterManagerBody({
    required this.inviteCode,
    required this.username,
    required this.name,
    required this.password,
  });

  factory RegisterManagerBody.fromJson(Map<String, dynamic> json) => _$RegisterManagerBodyFromJson(json);

  @JsonKey(name: 'invite_code')
  final String inviteCode;
  final String username;
  final String name;
  final String password;

  Map<String, dynamic> toJson() => _$RegisterManagerBodyToJson(this);

  @override
  List<Object?> get props => [inviteCode, username, name, password];
}
