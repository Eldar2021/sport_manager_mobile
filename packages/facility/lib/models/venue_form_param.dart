import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'venue_form_param.g.dart';

@immutable
@JsonSerializable(includeIfNull: false)
final class VenueFormParam extends Equatable {
  const VenueFormParam({
    required this.name,
    required this.number,
    this.address,
  });

  factory VenueFormParam.fromJson(Map<String, dynamic> json) {
    return _$VenueFormParamFromJson(json);
  }

  final String name;
  final int number;
  final String? address;

  Map<String, dynamic> toJson() {
    return _$VenueFormParamToJson(this);
  }

  @override
  List<Object?> get props => [
    name,
    number,
    address,
  ];
}
