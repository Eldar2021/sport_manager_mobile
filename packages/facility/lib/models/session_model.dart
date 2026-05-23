import 'package:equatable/equatable.dart';
import 'package:facility/facility.dart';

import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'session_model.g.dart';

@immutable
@JsonSerializable()
final class SessionModel extends Equatable {
  const SessionModel({
    required this.id,
    required this.spotId,
    required this.status,
    required this.startedAt,
    this.totalPausedSeconds = 0,
    this.pausedAt,
    this.tarifAmountSnapshot,
    this.tarifTypeSnapshot,
    this.endedAt,
    this.durationSeconds,
    this.subtotal,
    this.discountPercent,
    this.totalAmount,
    this.cancelReason,
    this.customerName,
    this.products = const [],
    this.productsAmount = 0,
  });

  factory SessionModel.fromJson(Map<String, dynamic> json) {
    // The embedded session shape (from venue/selected) omits `status` and uses
    // `active` + `paused` booleans instead. Normalise before generated decode.
    // TODO(eldiiar): Remove this workaround once the backend is consistent.
    if (json['status'] == null) {
      final active = json['active'] as bool? ?? false;
      final paused = json['paused'] as bool? ?? false;
      final statusStr = active ? (paused ? 'PAUSED' : 'ACTIVE') : 'COMPLETED';
      return _$SessionModelFromJson({...json, 'status': statusStr});
    }
    return _$SessionModelFromJson(json);
  }

  final String id;
  final String spotId;
  final SessionStatus status;
  final DateTime startedAt;
  final String? customerName;

  /// Accumulated paused seconds. Populated for ACTIVE / PAUSED sessions.
  final int totalPausedSeconds;

  /// Populated when status is PAUSED.
  final DateTime? pausedAt;

  /// Populated for ACTIVE / PAUSED sessions. Null for COMPLETED / CANCELLED.
  final int? tarifAmountSnapshot;

  /// Populated for ACTIVE / PAUSED sessions. Null for COMPLETED / CANCELLED.
  final TarifType? tarifTypeSnapshot;

  /// Populated for COMPLETED / CANCELLED sessions.
  final DateTime? endedAt;

  /// Null when status is CANCELLED.
  final int? durationSeconds;

  /// Null when status is CANCELLED.
  final int? subtotal;

  /// Null when status is CANCELLED.
  final int? discountPercent;

  /// Null when status is CANCELLED.
  final int? totalAmount;

  /// Null when status is COMPLETED.
  final String? cancelReason;

  final List<SessionProductItemModel> products;
  final int productsAmount;

  bool get isActive => status == SessionStatus.active;
  bool get isPaused => status == SessionStatus.paused;
  bool get isCompleted => status == SessionStatus.completed;
  bool get isCancelled => status == SessionStatus.cancelled;

  Map<String, dynamic> toJson() {
    return _$SessionModelToJson(this);
  }

  @override
  List<Object?> get props => [
    id,
    spotId,
    status,
    startedAt,
    totalPausedSeconds,
    pausedAt,
    tarifAmountSnapshot,
    tarifTypeSnapshot,
    endedAt,
    durationSeconds,
    subtotal,
    discountPercent,
    totalAmount,
    cancelReason,
    products,
    productsAmount,
  ];
}
