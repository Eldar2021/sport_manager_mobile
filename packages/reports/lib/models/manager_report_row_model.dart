import 'package:equatable/equatable.dart';
import 'package:facility/facility.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:reports/models/fraud_flag_model.dart';
import 'package:reports/models/manager_risk_band.dart';

part 'manager_report_row_model.g.dart';

@immutable
@JsonSerializable()
final class ManagerReportRowModel extends Equatable {
  const ManagerReportRowModel({
    required this.managerId,
    required this.name,
    required this.username,
    required this.revenue,
    required this.sessions,
    required this.cancelCount,
    required this.discountedCount,
    required this.avgDiscountPercent,
    required this.riskScore,
    required this.riskBand,
    required this.flags,
    required this.currency,
  });

  factory ManagerReportRowModel.fromJson(Map<String, dynamic> json) {
    return _$ManagerReportRowModelFromJson(json);
  }

  final String managerId;
  final String name;
  final String username;
  final int revenue;
  final int sessions;
  final int cancelCount;
  final int discountedCount;
  final int avgDiscountPercent;

  /// 0-100 — see [riskBand] for the bucketing.
  final int riskScore;
  final ManagerRiskBand riskBand;
  final List<FraudFlagModel> flags;
  final Currency currency;

  /// Cancel rate as a decimal (0.0-1.0). `0` when there are no sessions.
  double get cancelRate {
    final total = sessions + cancelCount;
    return total == 0 ? 0 : cancelCount / total;
  }

  Map<String, dynamic> toJson() => _$ManagerReportRowModelToJson(this);

  @override
  List<Object?> get props => [
    managerId,
    name,
    username,
    revenue,
    sessions,
    cancelCount,
    discountedCount,
    avgDiscountPercent,
    riskScore,
    riskBand,
    flags,
    currency,
  ];
}
