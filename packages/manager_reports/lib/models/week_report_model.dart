import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:manager_reports/manager_reports.dart';
import 'package:meta/meta.dart';

part 'week_report_model.g.dart';

/// Response of `?period=WEEK`. Always 7 rows in `days` (Monday → Sunday,
/// ISO 8601). Empty days come back as `isDayOff: true`.
@immutable
@JsonSerializable()
final class WeekReportModel extends Equatable {
  const WeekReportModel({
    required this.weekStart,
    required this.weekEnd,
    required this.summary,
    required this.days,
  });

  factory WeekReportModel.fromJson(Map<String, dynamic> json) => _$WeekReportModelFromJson(json);

  final DateTime weekStart;
  final DateTime weekEnd;
  final ReportSummaryModel summary;
  final List<DayCardModel> days;

  Map<String, dynamic> toJson() => _$WeekReportModelToJson(this);

  @override
  List<Object?> get props => [weekStart, weekEnd, summary, days];
}
