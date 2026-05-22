// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_product_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SessionProductItemModel _$SessionProductItemModelFromJson(
  Map<String, dynamic> json,
) => SessionProductItemModel(
  id: json['id'] as String,
  sessionId: json['sessionId'] as String,
  productId: json['productId'] as String,
  nameSnapshot: json['nameSnapshot'] as String,
  priceSnapshot: (json['priceSnapshot'] as num).toInt(),
  addedAt: DateTime.parse(json['addedAt'] as String),
);

Map<String, dynamic> _$SessionProductItemModelToJson(
  SessionProductItemModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'sessionId': instance.sessionId,
  'productId': instance.productId,
  'nameSnapshot': instance.nameSnapshot,
  'priceSnapshot': instance.priceSnapshot,
  'addedAt': instance.addedAt.toIso8601String(),
};
