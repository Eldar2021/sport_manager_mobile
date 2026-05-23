// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_create_param.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductCreateParam _$ProductCreateParamFromJson(Map<String, dynamic> json) => ProductCreateParam(
  name: json['name'] as String,
  price: (json['price'] as num).toInt(),
  unit: $enumDecode(_$ProductUnitEnumMap, json['unit']),
  category: $enumDecode(_$ProductCategoryEnumMap, json['category']),
  description: json['description'] as String?,
  photoUrl: json['photoUrl'] as String?,
  icon: json['icon'] as String?,
);

Map<String, dynamic> _$ProductCreateParamToJson(ProductCreateParam instance) => <String, dynamic>{
  'name': instance.name,
  'price': instance.price,
  'unit': _$ProductUnitEnumMap[instance.unit]!,
  'category': _$ProductCategoryEnumMap[instance.category]!,
  'description': ?instance.description,
  'photoUrl': ?instance.photoUrl,
  'icon': ?instance.icon,
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
