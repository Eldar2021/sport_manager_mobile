import 'package:equatable/equatable.dart';
import 'package:facility/models/currency.dart';
import 'package:facility/models/session_model.dart';
import 'package:facility/models/tarif_type.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'table_model.g.dart';

@immutable
@JsonSerializable()
final class TableModel extends Equatable {
  const TableModel({
    required this.id,
    required this.venueId,
    required this.number,
    required this.tarifAmount,
    required this.currency,
    required this.tarifType,
    required this.createdAt,
    required this.updatedAt,
    this.name,
    this.description,
    this.session,
  });

  factory TableModel.fromJson(Map<String, dynamic> json) {
    return _$TableModelFromJson(json);
  }

  final String id;
  final String venueId;
  final int number;
  final String? name;
  final String? description;
  final int tarifAmount;
  final Currency currency;
  final TarifType tarifType;
  final SessionModel? session;
  final DateTime createdAt;
  final DateTime updatedAt;

  bool get isOccupied => session != null;

  Map<String, dynamic> toJson() {
    return _$TableModelToJson(this);
  }

  TableModel copyWith({
    String? id,
    String? venueId,
    int? number,
    String? name,
    String? description,
    int? tarifAmount,
    Currency? currency,
    TarifType? tarifType,
    SessionModel? session,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TableModel(
      id: id ?? this.id,
      venueId: venueId ?? this.venueId,
      number: number ?? this.number,
      name: name ?? this.name,
      description: description ?? this.description,
      tarifAmount: tarifAmount ?? this.tarifAmount,
      currency: currency ?? this.currency,
      tarifType: tarifType ?? this.tarifType,
      session: session ?? this.session,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    venueId,
    number,
    name,
    description,
    tarifAmount,
    currency,
    tarifType,
    session,
    createdAt,
    updatedAt,
  ];
}
