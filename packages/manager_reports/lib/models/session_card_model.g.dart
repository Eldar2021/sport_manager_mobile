// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_card_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SessionCardModel _$SessionCardModelFromJson(Map<String, dynamic> json) => SessionCardModel(
  id: json['id'] as String,
  spotId: json['spotId'] as String,
  spotNumber: (json['spotNumber'] as num).toInt(),
  venueId: json['venueId'] as String,
  venueName: json['venueName'] as String,
  venueType: $enumDecode(_$VenueTypeEnumMap, json['venueType']),
  startedAt: DateTime.parse(json['startedAt'] as String),
  endedAt: DateTime.parse(json['endedAt'] as String),
  durationSeconds: (json['durationSeconds'] as num).toInt(),
  currency: $enumDecode(_$CurrencyEnumMap, json['currency']),
  subtotal: (json['subtotal'] as num).toInt(),
  productsAmount: (json['productsAmount'] as num).toInt(),
  totalAmount: (json['totalAmount'] as num).toInt(),
  spotName: json['spotName'] as String?,
  customerName: json['customerName'] as String?,
);

Map<String, dynamic> _$SessionCardModelToJson(SessionCardModel instance) => <String, dynamic>{
  'id': instance.id,
  'spotId': instance.spotId,
  'spotName': instance.spotName,
  'spotNumber': instance.spotNumber,
  'venueId': instance.venueId,
  'venueName': instance.venueName,
  'venueType': _$VenueTypeEnumMap[instance.venueType]!,
  'customerName': instance.customerName,
  'startedAt': instance.startedAt.toIso8601String(),
  'endedAt': instance.endedAt.toIso8601String(),
  'durationSeconds': instance.durationSeconds,
  'currency': _$CurrencyEnumMap[instance.currency]!,
  'subtotal': instance.subtotal,
  'productsAmount': instance.productsAmount,
  'totalAmount': instance.totalAmount,
};

const _$VenueTypeEnumMap = {
  VenueType.tableTennis: 'TABLE_TENNIS',
  VenueType.billiards: 'BILLIARDS',
  VenueType.playStation: 'PLAY_STATION',
  VenueType.volleyball: 'VOLLEYBALL',
  VenueType.basketball: 'BASKETBALL',
  VenueType.chess: 'CHESS',
  VenueType.football: 'FOOTBALL',
};

const _$CurrencyEnumMap = {
  Currency.kgs: 'KGS',
  Currency.usd: 'USD',
  Currency.rub: 'RUB',
  Currency.kzt: 'KZT',
  Currency.tryLira: 'TRY',
};
