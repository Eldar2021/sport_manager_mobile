// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'selected_venue_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SelectedVenueModel _$SelectedVenueModelFromJson(Map<String, dynamic> json) => SelectedVenueModel(
  venue: VenueModel.fromJson(json['venue'] as Map<String, dynamic>),
  spots: (json['spots'] as List<dynamic>).map((e) => SpotModel.fromJson(e as Map<String, dynamic>)).toList(),
);

Map<String, dynamic> _$SelectedVenueModelToJson(SelectedVenueModel instance) => <String, dynamic>{
  'venue': instance.venue,
  'spots': instance.spots,
};
