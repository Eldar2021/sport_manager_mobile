import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'report_venue_model.g.dart';

/// Lightweight venue payload used by the report venue-picker. Mirrors a
/// subset of `VenueModel` so the reports package doesn't pull in
/// session-related fields.
@immutable
@JsonSerializable()
final class ReportVenueModel extends Equatable {
  const ReportVenueModel({
    required this.id,
    required this.name,
    required this.number,
  });

  factory ReportVenueModel.fromJson(Map<String, dynamic> json) {
    return _$ReportVenueModelFromJson(json);
  }

  final String id;
  final String name;
  final int number;

  Map<String, dynamic> toJson() => _$ReportVenueModelToJson(this);

  @override
  List<Object?> get props => [
    id,
    name,
    number,
  ];
}
