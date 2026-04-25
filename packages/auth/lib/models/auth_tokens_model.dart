import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'auth_tokens_model.g.dart';

@immutable
@JsonSerializable()
final class AuthTokensModel extends Equatable {
  const AuthTokensModel({
    required this.accessToken,
    required this.refreshToken,
  });

  factory AuthTokensModel.fromJson(Map<String, dynamic> json) => _$AuthTokensModelFromJson(json);

  final String accessToken;
  final String refreshToken;

  Map<String, dynamic> toJson() => _$AuthTokensModelToJson(this);

  @override
  List<Object?> get props => [accessToken, refreshToken];
}
