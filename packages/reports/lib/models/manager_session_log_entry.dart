import 'package:equatable/equatable.dart';
import 'package:facility/facility.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'manager_session_log_entry.g.dart';

@JsonEnum()
enum ManagerSessionLogStatus {
  @JsonValue('ACTIVE')
  active,
  @JsonValue('COMPLETED')
  completed,
  @JsonValue('CANCELLED')
  cancelled,
}

/// One row of a manager's session log on the manager-detail page.
/// Slim by design — no per-session fraud signals (discount %, etc.); just
/// the facts an owner needs to scan their team's day.
@immutable
@JsonSerializable()
final class ManagerSessionLogEntry extends Equatable {
  const ManagerSessionLogEntry({
    required this.sessionId,
    required this.spotId,
    required this.spotNumber,
    required this.venueName,
    required this.startedAt,
    required this.status,
    required this.currency,
    this.customerName,
    this.endedAt,
    this.spotName,
    this.durationSeconds,
    this.totalAmount,
    this.cancelReason,
  });

  factory ManagerSessionLogEntry.fromJson(Map<String, dynamic> json) {
    return _$ManagerSessionLogEntryFromJson(json);
  }

  final String sessionId;
  final String spotId;
  final int spotNumber;
  final String? spotName;
  final String venueName;
  final String? customerName;
  final DateTime startedAt;
  final DateTime? endedAt;
  final ManagerSessionLogStatus status;
  final Currency currency;

  // Filled for COMPLETED:
  final int? durationSeconds;
  final int? totalAmount;

  // Filled for CANCELLED:
  final String? cancelReason;

  bool get isActive => status == ManagerSessionLogStatus.active;
  bool get isCancelled => status == ManagerSessionLogStatus.cancelled;

  Map<String, dynamic> toJson() => _$ManagerSessionLogEntryToJson(this);

  @override
  List<Object?> get props => [
    sessionId,
    spotId,
    spotNumber,
    spotName,
    venueName,
    customerName,
    startedAt,
    endedAt,
    status,
    currency,
    durationSeconds,
    totalAmount,
    cancelReason,
  ];
}
