import 'package:equatable/equatable.dart';
import 'package:facility/models/session_status.dart';
import 'package:facility/models/tarif_type.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'session_model.g.dart';

@immutable
@JsonSerializable()
final class SessionModel extends Equatable {
  const SessionModel({
    required this.id,
    required this.tableId,
    required this.status,
    required this.startedAt,
    required this.totalPausedSeconds,
    required this.tarifAmountSnapshot,
    required this.tarifTypeSnapshot,
    this.pausedAt,
  });

  factory SessionModel.fromJson(Map<String, dynamic> json) {
    return _$SessionModelFromJson(json);
  }

  final String id;
  final String tableId;
  final SessionStatus status;
  final DateTime startedAt;
  final DateTime? pausedAt;
  final int totalPausedSeconds;
  final int tarifAmountSnapshot;
  final TarifType tarifTypeSnapshot;

  bool get isPaused => status == SessionStatus.paused;
  bool get isActive => status == SessionStatus.active;

  Map<String, dynamic> toJson() {
    return _$SessionModelToJson(this);
  }

  @override
  List<Object?> get props => [
    id,
    tableId,
    status,
    startedAt,
    pausedAt,
    totalPausedSeconds,
    tarifAmountSnapshot,
    tarifTypeSnapshot,
  ];
}
