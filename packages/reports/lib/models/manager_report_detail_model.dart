import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:reports/models/manager_report_row_model.dart';
import 'package:reports/models/manager_session_log_entry.dart';

part 'manager_report_detail_model.g.dart';

@immutable
@JsonSerializable()
final class ManagerReportDetailModel extends Equatable {
  const ManagerReportDetailModel({
    required this.summary,
    required this.sessionLog,
  });

  factory ManagerReportDetailModel.fromJson(Map<String, dynamic> json) {
    return _$ManagerReportDetailModelFromJson(json);
  }

  final ManagerReportRowModel summary;
  final List<ManagerSessionLogEntry> sessionLog;

  Map<String, dynamic> toJson() => _$ManagerReportDetailModelToJson(this);

  @override
  List<Object?> get props => [
    summary,
    sessionLog,
  ];
}
