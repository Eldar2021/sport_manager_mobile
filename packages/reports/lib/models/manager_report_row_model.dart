import 'package:equatable/equatable.dart';
import 'package:facility/facility.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

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

  /// Number of CANCELLED sessions in the period — neutral data,
  /// shown only on the manager-detail KPI band.
  final int cancelCount;

  final Currency currency;

  Map<String, dynamic> toJson() => _$ManagerReportRowModelToJson(this);

  @override
  List<Object?> get props => [
    managerId,
    name,
    username,
    revenue,
    sessions,
    cancelCount,
    currency,
  ];
}
