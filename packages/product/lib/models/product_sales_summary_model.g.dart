// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_sales_summary_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductSalesSummaryModel _$ProductSalesSummaryModelFromJson(
  Map<String, dynamic> json,
) => ProductSalesSummaryModel(
  venueId: json['venueId'] as String,
  productId: json['productId'] as String,
  currentName: json['currentName'] as String,
  currentPrice: (json['currentPrice'] as num).toInt(),
  deleted: json['deleted'] as bool,
  period: json['period'] as String,
  from: DateTime.parse(json['from'] as String),
  to: DateTime.parse(json['to'] as String),
  sales: (json['sales'] as List<dynamic>).map((e) => ProductSaleModel.fromJson(e as Map<String, dynamic>)).toList(),
  totalCount: (json['totalCount'] as num).toInt(),
  totalAmount: (json['totalAmount'] as num).toInt(),
);

Map<String, dynamic> _$ProductSalesSummaryModelToJson(
  ProductSalesSummaryModel instance,
) => <String, dynamic>{
  'venueId': instance.venueId,
  'productId': instance.productId,
  'currentName': instance.currentName,
  'currentPrice': instance.currentPrice,
  'deleted': instance.deleted,
  'period': instance.period,
  'from': instance.from.toIso8601String(),
  'to': instance.to.toIso8601String(),
  'sales': instance.sales,
  'totalCount': instance.totalCount,
  'totalAmount': instance.totalAmount,
};
