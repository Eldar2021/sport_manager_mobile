import 'package:equatable/equatable.dart';
import 'package:facility/facility.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'table_report_row_model.g.dart';

/// Per-table row used by the Tables section and the Table Detail summary.
/// MVP: revenue + sessions only — avg-duration / occupancy were dropped
/// because the UI no longer surfaces them and synthetic-data deltas were
/// noisy.
@immutable
@JsonSerializable()
final class TableReportRowModel extends Equatable {
  const TableReportRowModel({
    required this.tableId,
    required this.tableNumber,
    required this.venueId,
    required this.venueName,
    required this.revenue,
    required this.sessions,
    required this.currency,
    this.tableName,
    this.deltaPercent,
  });

  factory TableReportRowModel.fromJson(Map<String, dynamic> json) {
    return _$TableReportRowModelFromJson(json);
  }

  final String tableId;
  final String? tableName;
  final int tableNumber;
  final String venueId;
  final String venueName;
  final int revenue;
  final int sessions;
  final Currency currency;

  /// Percent change vs previous period (`null` = not enough data).
  final int? deltaPercent;

  Map<String, dynamic> toJson() => _$TableReportRowModelToJson(this);

  @override
  List<Object?> get props => [
    tableId,
    tableName,
    tableNumber,
    venueId,
    venueName,
    revenue,
    sessions,
    currency,
    deltaPercent,
  ];
}
