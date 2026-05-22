// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'spot_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SpotModel _$SpotModelFromJson(Map<String, dynamic> json) => SpotModel(
  id: json['id'] as String,
  venueId: json['venueId'] as String,
  number: (json['number'] as num).toInt(),
  tarifAmount: (json['tarifAmount'] as num).toInt(),
  currency: $enumDecode(_$CurrencyEnumMap, json['currency']),
  tarifType: $enumDecode(_$TarifTypeEnumMap, json['tarifType']),
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
  name: json['name'] as String?,
  description: json['description'] as String?,
  session: json['session'] == null ? null : SessionModel.fromJson(json['session'] as Map<String, dynamic>),
);

Map<String, dynamic> _$SpotModelToJson(SpotModel instance) => <String, dynamic>{
  'id': instance.id,
  'venueId': instance.venueId,
  'number': instance.number,
  'name': instance.name,
  'description': instance.description,
  'tarifAmount': instance.tarifAmount,
  'currency': _$CurrencyEnumMap[instance.currency]!,
  'tarifType': _$TarifTypeEnumMap[instance.tarifType]!,
  'session': instance.session,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
};

const _$CurrencyEnumMap = {
  Currency.kgs: 'KGS',
  Currency.usd: 'USD',
  Currency.rub: 'RUB',
  Currency.kzt: 'KZT',
  Currency.tryLira: 'TRY',
};

const _$TarifTypeEnumMap = {
  TarifType.minute: 'MINUTE',
  TarifType.hour: 'HOUR',
  TarifType.day: 'DAY',
};
