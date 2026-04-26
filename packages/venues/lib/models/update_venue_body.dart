import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'update_venue_body.g.dart';

@immutable
@JsonSerializable(includeIfNull: false)
final class UpdateVenueBody extends Equatable {
  const UpdateVenueBody({
    this.name,
    this.number,
    this.address,
  });

  factory UpdateVenueBody.fromJson(Map<String, dynamic> json) {
    return _$UpdateVenueBodyFromJson(json);
  }

  final String? name;
  final String? number;
  final String? address;

  Map<String, dynamic> toJson() {
    return _$UpdateVenueBodyToJson(this);
  }

  @override
  List<Object?> get props => [
    name,
    number,
    address,
  ];
}
