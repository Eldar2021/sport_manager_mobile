import 'package:json_annotation/json_annotation.dart';

@JsonEnum()
enum VenueType {
  @JsonValue('TABLE_TENNIS')
  tableTennis,
  @JsonValue('BILLIARDS')
  billiards,
  @JsonValue('PLAY_STATION')
  playStation,
  @JsonValue('VOLLEYBALL')
  volleyball,
  @JsonValue('BASKETBALL')
  basketball,
  @JsonValue('CHESS')
  chess,
  @JsonValue('FOOTBALL')
  football,
}
