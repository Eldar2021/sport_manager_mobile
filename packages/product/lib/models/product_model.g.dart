// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductModel _$ProductModelFromJson(Map<String, dynamic> json) => ProductModel(
  id: json['id'] as String,
  ownerId: json['ownerId'] as String,
  name: json['name'] as String,
  price: (json['price'] as num).toInt(),
  unit: $enumDecode(_$ProductUnitEnumMap, json['unit']),
  category: $enumDecode(_$ProductCategoryEnumMap, json['category']),
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
  description: json['description'] as String?,
  photoUrl: json['photoUrl'] as String?,
);

Map<String, dynamic> _$ProductModelToJson(ProductModel instance) => <String, dynamic>{
  'id': instance.id,
  'ownerId': instance.ownerId,
  'name': instance.name,
  'price': instance.price,
  'unit': _$ProductUnitEnumMap[instance.unit]!,
  'category': _$ProductCategoryEnumMap[instance.category]!,
  'description': instance.description,
  'photoUrl': instance.photoUrl,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
};

const _$ProductUnitEnumMap = {
  ProductUnit.piece: 'PIECE',
  ProductUnit.kg: 'KG',
  ProductUnit.litre: 'LITRE',
  ProductUnit.portion: 'PORTION',
  ProductUnit.hour: 'HOUR',
};

const _$ProductCategoryEnumMap = {
  ProductCategory.drink: 'DRINK',
  ProductCategory.food: 'FOOD',
  ProductCategory.equipment: 'EQUIPMENT',
  ProductCategory.other: 'OTHER',
};
