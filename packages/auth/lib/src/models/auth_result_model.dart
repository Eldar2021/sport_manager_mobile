import 'package:auth/auth.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'auth_result_model.g.dart';

@immutable
@JsonSerializable()
final class AuthResultModel extends Equatable {
  const AuthResultModel({
    required this.token,
    required this.user,
  });

  factory AuthResultModel.fromJson(Map<String, dynamic> json) => _$AuthResultModelFromJson(json);

  final String token;
  final UserModel user;

  Map<String, dynamic> toJson() => _$AuthResultModelToJson(this);

  @override
  List<Object?> get props => [token, user];
}
