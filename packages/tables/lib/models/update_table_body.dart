import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'update_table_body.g.dart';

@immutable
@JsonSerializable(includeIfNull: false)
final class UpdateTableBody extends Equatable {
  const UpdateTableBody({
    this.number,
    this.name,
    this.hourlyRate,
  });

  factory UpdateTableBody.fromJson(Map<String, dynamic> json) => _$UpdateTableBodyFromJson(json);

  final String? number;
  final String? name;
  final int? hourlyRate;

  Map<String, dynamic> toJson() => _$UpdateTableBodyToJson(this);

  @override
  List<Object?> get props => [number, name, hourlyRate];
}
