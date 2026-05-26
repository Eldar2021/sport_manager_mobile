import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:manager_reports/manager_reports.dart';
import 'package:meta/meta.dart';

part 'year_report_model.g.dart';

/// Response of `?period=YEAR`. Always 12 rows (Jan → Dec). Future months
/// come back with `isFuture: true` and zero totals; the current month has
/// `isCurrent: true`.
@immutable
@JsonSerializable()
final class YearReportModel extends Equatable {
  const YearReportModel({
    required this.year,
    required this.summary,
    required this.months,
  });

  factory YearReportModel.fromJson(Map<String, dynamic> json) => _$YearReportModelFromJson(json);

  final int year;
  final ReportSummaryModel summary;
  final List<MonthCardModel> months;

  Map<String, dynamic> toJson() => _$YearReportModelToJson(this);

  @override
  List<Object?> get props => [year, summary, months];
}
