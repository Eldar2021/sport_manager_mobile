import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'create_table_body.g.dart';

@immutable
@JsonSerializable(includeIfNull: false)
final class CreateTableBody extends Equatable {
  const CreateTableBody({
    required this.number,
    required this.hourlyRate,
    this.name,
  });

  factory CreateTableBody.fromJson(Map<String, dynamic> json) {
    return _$CreateTableBodyFromJson(json);
  }

  final String number;
  final String? name;
  final int hourlyRate;

  Map<String, dynamic> toJson() {
    return _$CreateTableBodyToJson(this);
  }

  @override
  List<Object?> get props => [
    number,
    name,
    hourlyRate,
  ];
}
