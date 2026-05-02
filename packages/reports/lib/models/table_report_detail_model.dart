import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:reports/models/revenue_point_model.dart';
import 'package:reports/models/table_report_row_model.dart';

part 'table_report_detail_model.g.dart';

@immutable
@JsonSerializable()
final class TableReportDetailModel extends Equatable {
  const TableReportDetailModel({
    required this.summary,
    required this.revenueByDay,
    required this.hourHeatmap,
  });

  factory TableReportDetailModel.fromJson(Map<String, dynamic> json) {
    return _$TableReportDetailModelFromJson(json);
  }

  final TableReportRowModel summary;
  final List<RevenuePointModel> revenueByDay;

  /// 7×24 matrix (`hourHeatmap[weekday-1][hour]`) — revenue intensity per
  /// hour across the week. `weekday` follows ISO 8601 (1=Monday).
  final List<List<int>> hourHeatmap;

  Map<String, dynamic> toJson() => _$TableReportDetailModelToJson(this);

  @override
  List<Object?> get props => [
    summary,
    revenueByDay,
    hourHeatmap,
  ];
}
