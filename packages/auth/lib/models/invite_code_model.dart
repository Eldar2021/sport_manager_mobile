import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'invite_code_model.g.dart';

@immutable
@JsonSerializable()
final class InviteCodeModel extends Equatable {
  const InviteCodeModel({
    required this.code,
    this.expiresAt,
  });

  factory InviteCodeModel.fromJson(Map<String, dynamic> json) => _$InviteCodeModelFromJson(json);

  final String code;
  final DateTime? expiresAt;

  Map<String, dynamic> toJson() => _$InviteCodeModelToJson(this);

  @override
  List<Object?> get props => [code, expiresAt];
}
