import 'package:equatable/equatable.dart';
import 'package:facility/facility.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'reports_summary_model.g.dart';

/// Top-level KPI summary for the Reports overview. MVP scope is **revenue
/// + sessions** only — average-duration / occupancy / active-now were
/// dropped because synthetic data made the deltas meaningless and the
/// owner can read those signals from Table Detail (which keeps the per-
/// table revenue/session view).
@immutable
@JsonSerializable()
final class ReportsSummaryModel extends Equatable {
  const ReportsSummaryModel({
    required this.totalRevenue,
    required this.totalSessions,
    required this.cancelledSessions,
    required this.currency,
    this.previous,
  });

  factory ReportsSummaryModel.fromJson(Map<String, dynamic> json) {
    return _$ReportsSummaryModelFromJson(json);
  }

  final int totalRevenue;
  final int totalSessions;
  final int cancelledSessions;
  final Currency currency;

  /// Same shape, computed for the previous period of equal length. `null`
  /// when comparison is disabled or there is no prior data.
  final ReportsSummaryModel? previous;

  Map<String, dynamic> toJson() => _$ReportsSummaryModelToJson(this);

  /// Percent delta between current and previous values; `null` when there
  /// is no previous data or previous was zero (would divide by zero).
  int? _delta(int Function(ReportsSummaryModel s) pick) {
    final prev = previous;
    if (prev == null) return null;
    final p = pick(prev);
    if (p == 0) return null;
    final c = pick(this);
    return ((c - p) / p * 100).round();
  }

  int? get revenueDeltaPercent => _delta((s) => s.totalRevenue);
  int? get sessionsDeltaPercent => _delta((s) => s.totalSessions);

  @override
  List<Object?> get props => [
    totalRevenue,
    totalSessions,
    cancelledSessions,
    currency,
    previous,
  ];
}
