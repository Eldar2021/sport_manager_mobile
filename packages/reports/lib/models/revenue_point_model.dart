import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'revenue_point_model.g.dart';

@immutable
@JsonSerializable()
final class RevenuePointModel extends Equatable {
  const RevenuePointModel({
    required this.bucket,
    required this.revenue,
    required this.sessions,
  });

  factory RevenuePointModel.fromJson(Map<String, dynamic> json) {
    return _$RevenuePointModelFromJson(json);
  }

  /// Start of the time bucket (day for week/month, hour for today, month for year).
  final DateTime bucket;
  final int revenue;
  final int sessions;

  Map<String, dynamic> toJson() => _$RevenuePointModelToJson(this);

  @override
  List<Object?> get props => [
    bucket,
    revenue,
    sessions,
  ];
}
