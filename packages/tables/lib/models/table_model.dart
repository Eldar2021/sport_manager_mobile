import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:tables/models/table_status.dart';

part 'table_model.g.dart';

@immutable
@JsonSerializable()
final class TableModel extends Equatable {
  const TableModel({
    required this.id,
    required this.venueId,
    required this.number,
    required this.hourlyRate,
    required this.status,
    this.name,
    this.description,
  });

  factory TableModel.fromJson(Map<String, dynamic> json) {
    return _$TableModelFromJson(json);
  }

  final String id;
  final String venueId;
  final String number;
  final String? name;
  final int hourlyRate;
  final TableStatus status;
  final String? description;

  bool get isAvailable => status == TableStatus.available;

  Map<String, dynamic> toJson() {
    return _$TableModelToJson(this);
  }

  @override
  List<Object?> get props => [
    id,
    venueId,
    number,
    name,
    hourlyRate,
    status,
    description,
  ];
}
