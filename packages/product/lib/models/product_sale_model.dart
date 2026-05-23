import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'product_sale_model.g.dart';

@JsonSerializable()
@immutable
final class ProductSaleModel extends Equatable {
  const ProductSaleModel({
    required this.sessionId,
    required this.itemId,
    required this.priceSnapshot,
    required this.nameSnapshot,
    required this.soldAt,
    this.sessionEndedAt,
  });

  factory ProductSaleModel.fromJson(Map<String, dynamic> json) {
    return _$ProductSaleModelFromJson(json);
  }

  final String sessionId;
  final String itemId;
  final int priceSnapshot;
  final String nameSnapshot;
  final DateTime soldAt;
  final DateTime? sessionEndedAt;

  Map<String, dynamic> toJson() {
    return _$ProductSaleModelToJson(this);
  }

  @override
  List<Object?> get props => [
    sessionId,
    itemId,
    priceSnapshot,
    nameSnapshot,
    soldAt,
    sessionEndedAt,
  ];
}
