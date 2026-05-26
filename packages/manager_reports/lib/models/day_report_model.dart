import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:manager_reports/manager_reports.dart';
import 'package:meta/meta.dart';

part 'day_report_model.g.dart';

/// Used by both `?period=TODAY` and `/days/{date}` — backend returns the
/// same shape for both ("DayDetail = TodayReport" in the spec).
///
/// `sessions` is ordered by `startedAt ASC` and may be empty for a
/// rest day; in that case `summary` totals are all zero.
@immutable
@JsonSerializable()
final class DayReportModel extends Equatable {
  const DayReportModel({
    required this.date,
    required this.dayOfWeek,
    required this.summary,
    required this.sessions,
  });

  factory DayReportModel.fromJson(Map<String, dynamic> json) => _$DayReportModelFromJson(json);

  final DateTime date;
  final DayOfWeek dayOfWeek;
  final ReportSummaryModel summary;
  final List<SessionCardModel> sessions;

  Map<String, dynamic> toJson() => _$DayReportModelToJson(this);

  @override
  List<Object?> get props => [date, dayOfWeek, summary, sessions];
}
