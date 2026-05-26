import 'package:equatable/equatable.dart';
import 'package:facility/facility.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'session_card_model.g.dart';

/// A single session row in `TODAY` / `DayDetail` lists.
@immutable
@JsonSerializable()
final class SessionCardModel extends Equatable {
  const SessionCardModel({
    required this.id,
    required this.spotId,
    required this.spotNumber,
    required this.venueId,
    required this.venueName,
    required this.venueType,
    required this.startedAt,
    required this.endedAt,
    required this.durationSeconds,
    required this.currency,
    required this.subtotal,
    required this.productsAmount,
    required this.totalAmount,
    this.spotName,
    this.customerName,
  });

  factory SessionCardModel.fromJson(Map<String, dynamic> json) => _$SessionCardModelFromJson(json);

  final String id;
  final String spotId;
  final String? spotName;
  final int spotNumber;
  final String venueId;
  final String venueName;
  final VenueType venueType;
  final String? customerName;
  final DateTime startedAt;
  final DateTime endedAt;
  final int durationSeconds;
  final Currency currency;

  /// Time-based subtotal after discount.
  final int subtotal;

  /// Sum of session products snapshots; may be 0.
  final int productsAmount;

  /// `subtotal + productsAmount`.
  final int totalAmount;

  Map<String, dynamic> toJson() => _$SessionCardModelToJson(this);

  @override
  List<Object?> get props => [
    id,
    spotId,
    spotName,
    spotNumber,
    venueId,
    venueName,
    venueType,
    customerName,
    startedAt,
    endedAt,
    durationSeconds,
    currency,
    subtotal,
    productsAmount,
    totalAmount,
  ];
}
