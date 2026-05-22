import 'package:equatable/equatable.dart';
import 'package:facility/facility.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'spot_report_row_model.g.dart';

/// Per-spot row used by the Spots section and the Spot Detail summary.
/// MVP: revenue + sessions only — avg-duration / occupancy were dropped
/// because the UI no longer surfaces them and synthetic-data deltas were
/// noisy.
@immutable
@JsonSerializable()
final class SpotReportRowModel extends Equatable {
  const SpotReportRowModel({
    required this.spotId,
    required this.spotNumber,
    required this.venueId,
    required this.venueName,
    required this.revenue,
    required this.sessions,
    required this.currency,
    this.spotName,
    this.deltaPercent,
  });

  factory SpotReportRowModel.fromJson(Map<String, dynamic> json) {
    return _$SpotReportRowModelFromJson(json);
  }

  final String spotId;
  final String? spotName;
  final int spotNumber;
  final String venueId;
  final String venueName;
  final int revenue;
  final int sessions;
  final Currency currency;

  /// Percent change vs previous period (`null` = not enough data).
  final int? deltaPercent;

  Map<String, dynamic> toJson() => _$SpotReportRowModelToJson(this);

  @override
  List<Object?> get props => [
    spotId,
    spotName,
    spotNumber,
    venueId,
    venueName,
    revenue,
    sessions,
    currency,
    deltaPercent,
  ];
}
