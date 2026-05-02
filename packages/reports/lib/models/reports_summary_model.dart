import 'package:equatable/equatable.dart';
import 'package:facility/facility.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'reports_summary_model.g.dart';

@immutable
@JsonSerializable()
final class ReportsSummaryModel extends Equatable {
  const ReportsSummaryModel({
    required this.totalRevenue,
    required this.totalSessions,
    required this.cancelledSessions,
    required this.avgDurationSeconds,
    required this.occupancyPercent,
    required this.activeNow,
    required this.activeMax,
    required this.currency,
    this.previous,
  });

  factory ReportsSummaryModel.fromJson(Map<String, dynamic> json) {
    return _$ReportsSummaryModelFromJson(json);
  }

  final int totalRevenue;
  final int totalSessions;
  final int cancelledSessions;
  final int avgDurationSeconds;
  final int occupancyPercent;
  final int activeNow;
  final int activeMax;
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
  int? get avgDurationDeltaPercent => _delta((s) => s.avgDurationSeconds);
  int? get occupancyDeltaPercent => _delta((s) => s.occupancyPercent);

  @override
  List<Object?> get props => [
    totalRevenue,
    totalSessions,
    cancelledSessions,
    avgDurationSeconds,
    occupancyPercent,
    activeNow,
    activeMax,
    currency,
    previous,
  ];
}
