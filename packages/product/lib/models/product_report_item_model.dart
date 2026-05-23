import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:product/product.dart';

part 'product_report_item_model.g.dart';

@JsonSerializable()
@immutable
final class ProductReportItemModel extends Equatable {
  const ProductReportItemModel({
    required this.productId,
    required this.name,
    required this.category,
    required this.totalCount,
    required this.totalAmount,
    required this.deleted,
  });

  factory ProductReportItemModel.fromJson(Map<String, dynamic> json) {
    return _$ProductReportItemModelFromJson(json);
  }

  final String productId;
  final String name;
  final ProductCategory category;
  final int totalCount;
  final int totalAmount;
  final bool deleted;

  Map<String, dynamic> toJson() {
    return _$ProductReportItemModelToJson(this);
  }

  @override
  List<Object?> get props => [
    productId,
    name,
    category,
    totalCount,
    totalAmount,
    deleted,
  ];
}
