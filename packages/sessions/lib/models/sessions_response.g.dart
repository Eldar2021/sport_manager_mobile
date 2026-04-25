// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sessions_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SessionsResponse _$SessionsResponseFromJson(Map<String, dynamic> json) => SessionsResponse(
  items: (json['items'] as List<dynamic>).map((e) => SessionModel.fromJson(e as Map<String, dynamic>)).toList(),
  total: (json['total'] as num).toInt(),
  page: (json['page'] as num).toInt(),
  limit: (json['limit'] as num).toInt(),
);

Map<String, dynamic> _$SessionsResponseToJson(SessionsResponse instance) => <String, dynamic>{
  'items': instance.items,
  'total': instance.total,
  'page': instance.page,
  'limit': instance.limit,
};
