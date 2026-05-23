import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:product/product.dart';

part 'product_sales_summary_model.g.dart';

@JsonSerializable()
@immutable
final class ProductSalesSummaryModel extends Equatable {
  const ProductSalesSummaryModel({
    required this.venueId,
    required this.productId,
    required this.currentName,
    required this.currentPrice,
    required this.deleted,
    required this.period,
    required this.from,
    required this.to,
    required this.sales,
    required this.totalCount,
    required this.totalAmount,
  });

  factory ProductSalesSummaryModel.fromJson(Map<String, dynamic> json) {
    return _$ProductSalesSummaryModelFromJson(json);
  }

  final String venueId;
  final String productId;
  final String currentName;
  final int currentPrice;
  final bool deleted;
  final String period;
  final DateTime from;
  final DateTime to;
  final List<ProductSaleModel> sales;
  final int totalCount;
  final int totalAmount;

  Map<String, dynamic> toJson() {
    return _$ProductSalesSummaryModelToJson(this);
  }

  @override
  List<Object?> get props => [
    venueId,
    productId,
    currentName,
    currentPrice,
    deleted,
    period,
    from,
    to,
    sales,
    totalCount,
    totalAmount,
  ];
}
