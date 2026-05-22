// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_report_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductReportItemModel _$ProductReportItemModelFromJson(
  Map<String, dynamic> json,
) => ProductReportItemModel(
  productId: json['productId'] as String,
  name: json['name'] as String,
  category: $enumDecode(_$ProductCategoryEnumMap, json['category']),
  totalCount: (json['totalCount'] as num).toInt(),
  totalAmount: (json['totalAmount'] as num).toInt(),
  deleted: json['deleted'] as bool,
);

Map<String, dynamic> _$ProductReportItemModelToJson(
  ProductReportItemModel instance,
) => <String, dynamic>{
  'productId': instance.productId,
  'name': instance.name,
  'category': _$ProductCategoryEnumMap[instance.category]!,
  'totalCount': instance.totalCount,
  'totalAmount': instance.totalAmount,
  'deleted': instance.deleted,
};

const _$ProductCategoryEnumMap = {
  ProductCategory.drink: 'DRINK',
  ProductCategory.food: 'FOOD',
  ProductCategory.equipment: 'EQUIPMENT',
  ProductCategory.other: 'OTHER',
};
