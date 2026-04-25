import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:sessions/models/session_status.dart';

part 'session_model.g.dart';

@immutable
@JsonSerializable()
final class SessionModel extends Equatable {
  const SessionModel({
    required this.id,
    required this.tableId,
    required this.venueId,
    required this.managerId,
    required this.startedAt,
    required this.hourlyRateSnapshot,
    required this.discountPercent,
    required this.status,
    this.endedAt,
    this.durationSeconds,
    this.subtotal,
    this.totalAmount,
    this.notes,
  });

  factory SessionModel.fromJson(Map<String, dynamic> json) => _$SessionModelFromJson(json);

  final String id;
  final String tableId;
  final String venueId;
  final String managerId;
  final DateTime startedAt;
  final DateTime? endedAt;
  final int? durationSeconds;
  final int hourlyRateSnapshot;
  final int? subtotal;
  final int discountPercent;
  final int? totalAmount;
  final SessionStatus status;
  final String? notes;

  bool get isActive => status == SessionStatus.active;

  Map<String, dynamic> toJson() => _$SessionModelToJson(this);

  @override
  List<Object?> get props => [
    id,
    tableId,
    venueId,
    managerId,
    startedAt,
    endedAt,
    durationSeconds,
    hourlyRateSnapshot,
    subtotal,
    discountPercent,
    totalAmount,
    status,
    notes,
  ];
}
