import 'package:equatable/equatable.dart';
import 'package:facility/facility.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'forecast_model.g.dart';

@immutable
@JsonSerializable()
final class ForecastPointModel extends Equatable {
  const ForecastPointModel({
    required this.bucket,
    required this.expected,
    required this.lower,
    required this.upper,
    required this.projection,
  });

  factory ForecastPointModel.fromJson(Map<String, dynamic> json) {
    return _$ForecastPointModelFromJson(json);
  }

  final DateTime bucket;
  final int expected;
  final int lower;
  final int upper;

  /// `true` when this point is in the future (projected). `false` for actual
  /// historical values plotted on the same axis.
  final bool projection;

  Map<String, dynamic> toJson() => _$ForecastPointModelToJson(this);

  @override
  List<Object?> get props => [
    bucket,
    expected,
    lower,
    upper,
    projection,
  ];
}

@immutable
@JsonSerializable()
final class ForecastModel extends Equatable {
  const ForecastModel({
    required this.points,
    required this.projectedTotal,
    required this.previousPeriodTotal,
    required this.currency,
  });

  factory ForecastModel.fromJson(Map<String, dynamic> json) {
    return _$ForecastModelFromJson(json);
  }

  final List<ForecastPointModel> points;

  /// Total expected revenue for the projected window.
  final int projectedTotal;

  /// Same metric for the previous period of equal length — used to print
  /// "+12% vs Nisan" style copy.
  final int previousPeriodTotal;
  final Currency currency;

  /// Percent delta vs the previous period. `null` when previous is zero.
  int? get deltaPercent {
    if (previousPeriodTotal == 0) return null;
    return ((projectedTotal - previousPeriodTotal) / previousPeriodTotal * 100).round();
  }

  Map<String, dynamic> toJson() => _$ForecastModelToJson(this);

  @override
  List<Object?> get props => [
    points,
    projectedTotal,
    previousPeriodTotal,
    currency,
  ];
}
