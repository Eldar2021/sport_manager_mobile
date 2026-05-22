import 'package:equatable/equatable.dart';
import 'package:facility/models/venue_type.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'venue_model.g.dart';

@immutable
@JsonSerializable()
final class VenueModel extends Equatable {
  const VenueModel({
    required this.id,
    required this.name,
    required this.number,
    required this.type,
    required this.selected,
    required this.spotCount,
    required this.createdAt,
    required this.updatedAt,
    this.address,
  });

  factory VenueModel.fromJson(Map<String, dynamic> json) {
    return _$VenueModelFromJson(json);
  }

  final String id;
  final String name;
  final int number;
  final VenueType type;
  final String? address;
  final bool selected;
  final int spotCount;
  final DateTime createdAt;
  final DateTime updatedAt;

  Map<String, dynamic> toJson() {
    return _$VenueModelToJson(this);
  }

  @override
  List<Object?> get props => [
    id,
    name,
    number,
    type,
    address,
    selected,
    spotCount,
    createdAt,
    updatedAt,
  ];
}
