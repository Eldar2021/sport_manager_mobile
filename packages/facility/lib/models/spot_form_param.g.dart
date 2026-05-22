// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'spot_form_param.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SpotFormParam _$SpotFormParamFromJson(Map<String, dynamic> json) => SpotFormParam(
  venueId: json['venueId'] as String,
  number: (json['number'] as num).toInt(),
  tarifAmount: (json['tarifAmount'] as num).toInt(),
  currency: $enumDecode(_$CurrencyEnumMap, json['currency']),
  tarifType: $enumDecode(_$TarifTypeEnumMap, json['tarifType']),
  name: json['name'] as String?,
  description: json['description'] as String?,
);

Map<String, dynamic> _$SpotFormParamToJson(SpotFormParam instance) => <String, dynamic>{
  'venueId': instance.venueId,
  'number': instance.number,
  'name': ?instance.name,
  'description': ?instance.description,
  'tarifAmount': instance.tarifAmount,
  'currency': _$CurrencyEnumMap[instance.currency]!,
  'tarifType': _$TarifTypeEnumMap[instance.tarifType]!,
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
