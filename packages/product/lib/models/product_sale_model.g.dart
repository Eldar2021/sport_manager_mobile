// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_sale_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductSaleModel _$ProductSaleModelFromJson(Map<String, dynamic> json) => ProductSaleModel(
  sessionId: json['sessionId'] as String,
  itemId: json['itemId'] as String,
  priceSnapshot: (json['priceSnapshot'] as num).toInt(),
  nameSnapshot: json['nameSnapshot'] as String,
  soldAt: DateTime.parse(json['soldAt'] as String),
  sessionEndedAt: json['sessionEndedAt'] == null ? null : DateTime.parse(json['sessionEndedAt'] as String),
);

Map<String, dynamic> _$ProductSaleModelToJson(ProductSaleModel instance) => <String, dynamic>{
  'sessionId': instance.sessionId,
  'itemId': instance.itemId,
  'priceSnapshot': instance.priceSnapshot,
  'nameSnapshot': instance.nameSnapshot,
  'soldAt': instance.soldAt.toIso8601String(),
  'sessionEndedAt': instance.sessionEndedAt?.toIso8601String(),
};
