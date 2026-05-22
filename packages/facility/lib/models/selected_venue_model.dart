import 'package:equatable/equatable.dart';
import 'package:facility/models/spot_model.dart';
import 'package:facility/models/venue_model.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'selected_venue_model.g.dart';

@immutable
@JsonSerializable()
final class SelectedVenueModel extends Equatable {
  const SelectedVenueModel({
    required this.venue,
    required this.spots,
  });

  factory SelectedVenueModel.fromJson(Map<String, dynamic> json) {
    return _$SelectedVenueModelFromJson(json);
  }

  final VenueModel venue;
  final List<SpotModel> spots;

  Map<String, dynamic> toJson() {
    return _$SelectedVenueModelToJson(this);
  }

  @override
  List<Object?> get props => [
    venue,
    spots,
  ];
}
