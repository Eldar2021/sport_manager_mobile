import 'package:equatable/equatable.dart';
import 'package:facility/facility.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'report_summary_model.g.dart';

/// Top summary card source — totals for the selected window.
@immutable
@JsonSerializable()
final class ReportSummaryModel extends Equatable {
  const ReportSummaryModel({
    required this.revenue,
    required this.currency,
    required this.sessions,
    required this.shiftSeconds,
  });

  factory ReportSummaryModel.fromJson(Map<String, dynamic> json) => _$ReportSummaryModelFromJson(json);

  final int revenue;
  final Currency currency;
  final int sessions;
  final int shiftSeconds;

  Map<String, dynamic> toJson() => _$ReportSummaryModelToJson(this);

  @override
  List<Object?> get props => [revenue, currency, sessions, shiftSeconds];
}
