import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:product/product.dart';

part 'product_report_summary_model.g.dart';

@JsonSerializable()
@immutable
final class ProductReportSummaryModel extends Equatable {
  const ProductReportSummaryModel({
    required this.venueId,
    required this.period,
    required this.from,
    required this.to,
    required this.items,
    required this.totalAmount,
  });

  factory ProductReportSummaryModel.fromJson(Map<String, dynamic> json) {
    return _$ProductReportSummaryModelFromJson(json);
  }

  final String venueId;
  final String period;
  final DateTime from;
  final DateTime to;
  final List<ProductReportItemModel> items;
  final int totalAmount;

  Map<String, dynamic> toJson() {
    return _$ProductReportSummaryModelToJson(this);
  }

  @override
  List<Object?> get props => [
    venueId,
    period,
    from,
    to,
    items,
    totalAmount,
  ];
}
