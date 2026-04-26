import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'venue_model.g.dart';

@immutable
@JsonSerializable()
final class VenueModel extends Equatable {
  const VenueModel({
    required this.id,
    required this.ownerId,
    required this.name,
    required this.number,
    required this.isActive,
    this.address,
  });

  factory VenueModel.fromJson(Map<String, dynamic> json) {
    return _$VenueModelFromJson(json);
  }

  final String id;
  final String ownerId;
  final String name;
  final String number;
  final bool isActive;
  final String? address;

  Map<String, dynamic> toJson() {
    return _$VenueModelToJson(this);
  }

  @override
  List<Object?> get props => [
    id,
    ownerId,
    name,
    number,
    isActive,
    address,
  ];
}
