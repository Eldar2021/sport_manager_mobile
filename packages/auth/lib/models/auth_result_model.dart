import 'package:auth/models/auth_tokens_model.dart';
import 'package:auth/models/user_model.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'auth_result_model.g.dart';

@immutable
@JsonSerializable()
final class AuthResultModel extends Equatable {
  const AuthResultModel({
    required this.user,
    required this.accessToken,
    required this.refreshToken,
  });

  factory AuthResultModel.fromJson(Map<String, dynamic> json) => _$AuthResultModelFromJson(json);

  final UserModel user;
  final String accessToken;
  final String refreshToken;

  AuthTokensModel get tokens => AuthTokensModel(
    accessToken: accessToken,
    refreshToken: refreshToken,
  );

  Map<String, dynamic> toJson() => _$AuthResultModelToJson(this);

  @override
  List<Object?> get props => [user, accessToken, refreshToken];
}
