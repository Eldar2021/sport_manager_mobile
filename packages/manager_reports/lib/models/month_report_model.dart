import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:manager_reports/manager_reports.dart';
import 'package:meta/meta.dart';

part 'month_report_model.g.dart';

/// Used by both `?period=MONTH` and `/months/{yearMonth}` — same shape
/// ("MonthDetail = MonthReport" in the spec). `days` length matches the
/// month's day count (28-31). Future days come back with `isFuture: true`,
/// zero-session days with `isDayOff: true`.
@immutable
@JsonSerializable()
final class MonthReportModel extends Equatable {
  const MonthReportModel({
    required this.year,
    required this.month,
    required this.monthShort,
    required this.summary,
    required this.days,
  });

  factory MonthReportModel.fromJson(Map<String, dynamic> json) => _$MonthReportModelFromJson(json);

  final int year;

  /// 1-12.
  final int month;
  final MonthShort monthShort;
  final ReportSummaryModel summary;
  final List<DayCardModel> days;

  Map<String, dynamic> toJson() => _$MonthReportModelToJson(this);

  @override
  List<Object?> get props => [year, month, monthShort, summary, days];
}
