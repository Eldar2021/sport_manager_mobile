import 'package:equatable/equatable.dart';
import 'package:facility/facility.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:manager_reports/manager_reports.dart';
import 'package:meta/meta.dart';

part 'month_card_model.g.dart';

/// A single month row in the year view. `progressRatio` is normalized
/// against the highest-revenue month within the same year (0..1).
@immutable
@JsonSerializable()
final class MonthCardModel extends Equatable {
  const MonthCardModel({
    required this.year,
    required this.month,
    required this.monthShort,
    required this.revenue,
    required this.currency,
    required this.sessions,
    required this.shiftSeconds,
    required this.isCurrent,
    required this.isFuture,
    required this.progressRatio,
  });

  factory MonthCardModel.fromJson(Map<String, dynamic> json) => _$MonthCardModelFromJson(json);

  final int year;

  /// 1-12.
  final int month;
  final MonthShort monthShort;
  final int revenue;
  final Currency currency;
  final int sessions;
  final int shiftSeconds;
  final bool isCurrent;
  final bool isFuture;

  /// `revenue / max(revenue across the 12 months)`; 0.0 when no data.
  final double progressRatio;

  Map<String, dynamic> toJson() => _$MonthCardModelToJson(this);

  @override
  List<Object?> get props => [
    year,
    month,
    monthShort,
    revenue,
    currency,
    sessions,
    shiftSeconds,
    isCurrent,
    isFuture,
    progressRatio,
  ];
}
