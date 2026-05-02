import 'package:equatable/equatable.dart';
import 'package:facility/facility.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'manager_session_log_entry.g.dart';

@JsonEnum()
enum ManagerSessionLogStatus {
  @JsonValue('COMPLETED')
  completed,
  @JsonValue('CANCELLED')
  cancelled,
}

@immutable
@JsonSerializable()
final class ManagerSessionLogEntry extends Equatable {
  const ManagerSessionLogEntry({
    required this.sessionId,
    required this.tableId,
    required this.tableNumber,
    required this.venueName,
    required this.startedAt,
    required this.endedAt,
    required this.status,
    required this.currency,
    this.tableName,
    this.durationSeconds,
    this.totalAmount,
    this.discountPercent,
    this.cancelReason,
  });

  factory ManagerSessionLogEntry.fromJson(Map<String, dynamic> json) {
    return _$ManagerSessionLogEntryFromJson(json);
  }

  final String sessionId;
  final String tableId;
  final int tableNumber;
  final String? tableName;
  final String venueName;
  final DateTime startedAt;
  final DateTime endedAt;
  final ManagerSessionLogStatus status;
  final Currency currency;

  // Filled for COMPLETED:
  final int? durationSeconds;
  final int? totalAmount;
  final int? discountPercent;

  // Filled for CANCELLED:
  final String? cancelReason;

  bool get isCancelled => status == ManagerSessionLogStatus.cancelled;
  bool get hadDiscount => (discountPercent ?? 0) > 0;
  bool get isShort => (durationSeconds ?? 0) < 5 * 60;

  Map<String, dynamic> toJson() => _$ManagerSessionLogEntryToJson(this);

  @override
  List<Object?> get props => [
    sessionId,
    tableId,
    tableNumber,
    tableName,
    venueName,
    startedAt,
    endedAt,
    status,
    currency,
    durationSeconds,
    totalAmount,
    discountPercent,
    cancelReason,
  ];
}
