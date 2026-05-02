// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'revenue_point_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RevenuePointModel _$RevenuePointModelFromJson(Map<String, dynamic> json) => RevenuePointModel(
  bucket: DateTime.parse(json['bucket'] as String),
  revenue: (json['revenue'] as num).toInt(),
  sessions: (json['sessions'] as num).toInt(),
);

Map<String, dynamic> _$RevenuePointModelToJson(RevenuePointModel instance) => <String, dynamic>{
  'bucket': instance.bucket.toIso8601String(),
  'revenue': instance.revenue,
  'sessions': instance.sessions,
};
