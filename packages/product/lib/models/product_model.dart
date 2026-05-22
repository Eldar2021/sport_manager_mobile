import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:product/product.dart';

part 'product_model.g.dart';

@JsonSerializable()
@immutable
final class ProductModel extends Equatable {
  const ProductModel({
    required this.id,
    required this.ownerId,
    required this.name,
    required this.price,
    required this.unit,
    required this.category,
    required this.createdAt,
    required this.updatedAt,
    this.description,
    this.photoUrl,
    this.icon,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return _$ProductModelFromJson(json);
  }

  final String id;
  final String ownerId;
  final String name;
  final int price;
  final ProductUnit unit;
  final ProductCategory category;
  final String? description;
  final String? photoUrl;
  final String? icon;
  final DateTime createdAt;
  final DateTime updatedAt;

  Map<String, dynamic> toJson() {
    return _$ProductModelToJson(this);
  }

  @override
  List<Object?> get props => [
    id,
    ownerId,
    name,
    price,
    unit,
    category,
    description,
    photoUrl,
    icon,
    updatedAt,
  ];
}
