import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:reports/models/revenue_point_model.dart';
import 'package:reports/models/spot_report_row_model.dart';

part 'spot_report_detail_model.g.dart';

@immutable
@JsonSerializable()
final class SpotReportDetailModel extends Equatable {
  const SpotReportDetailModel({
    required this.summary,
    required this.revenueSeries,
    required this.hourHeatmap,
  });

  factory SpotReportDetailModel.fromJson(Map<String, dynamic> json) {
    return _$SpotReportDetailModelFromJson(json);
  }

  final SpotReportRowModel summary;
  final List<RevenuePointModel> revenueSeries;

  /// 7×24 matrix (`hourHeatmap[weekday-1][hour]`) — revenue intensity per
  /// hour across the week. `weekday` follows ISO 8601 (1=Monday).
  final List<List<int>> hourHeatmap;

  Map<String, dynamic> toJson() => _$SpotReportDetailModelToJson(this);

  @override
  List<Object?> get props => [
    summary,
    revenueSeries,
    hourHeatmap,
  ];
}
