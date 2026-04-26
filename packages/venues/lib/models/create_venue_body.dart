import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'create_venue_body.g.dart';

@immutable
@JsonSerializable(includeIfNull: false)
final class CreateVenueBody extends Equatable {
  const CreateVenueBody({
    required this.name,
    required this.number,
    this.address,
  });

  factory CreateVenueBody.fromJson(Map<String, dynamic> json) {
    return _$CreateVenueBodyFromJson(json);
  }

  final String name;
  final String number;
  final String? address;

  Map<String, dynamic> toJson() {
    return _$CreateVenueBodyToJson(this);
  }

  @override
  List<Object?> get props => [
    name,
    number,
    address,
  ];
}
