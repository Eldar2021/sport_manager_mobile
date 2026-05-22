import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:product/product.dart';

part 'product_create_param.g.dart';

@JsonSerializable(includeIfNull: false)
@immutable
final class ProductCreateParam extends Equatable {
  const ProductCreateParam({
    required this.name,
    required this.price,
    required this.unit,
    required this.category,
    this.description,
    this.photoUrl,
  });

  factory ProductCreateParam.fromJson(Map<String, dynamic> json) {
    return _$ProductCreateParamFromJson(json);
  }

  final String name;
  final int price;
  final ProductUnit unit;
  final ProductCategory category;
  final String? description;
  final String? photoUrl;

  Map<String, dynamic> toJson() {
    return _$ProductCreateParamToJson(this);
  }

  @override
  List<Object?> get props => [
    name,
    price,
    unit,
    category,
    description,
    photoUrl,
  ];
}
