import 'package:equatable/equatable.dart';
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
    required this.isActive,
    required this.isPaused,
    required this.startedAt,
    required this.totalPausedSeconds,
    required this.tarifAmountSnapshot,
    required this.tarifTypeSnapshot,
    this.pausedAt,
    this.resumedAt,
  });

  factory SessionModel.fromJson(Map<String, dynamic> json) {
    return _$SessionModelFromJson(json);
  }

  final String id;
  final String tableId;
  final bool isActive;
  final bool isPaused;
  final DateTime startedAt;
  final DateTime? pausedAt;
  final DateTime? resumedAt;
  final int totalPausedSeconds;
  final int tarifAmountSnapshot;
  final TarifType tarifTypeSnapshot;

  Map<String, dynamic> toJson() {
    return _$SessionModelToJson(this);
  }

  @override
  List<Object?> get props => [
    id,
    tableId,
    isActive,
    isPaused,
    startedAt,
    pausedAt,
    resumedAt,
    totalPausedSeconds,
    tarifAmountSnapshot,
    tarifTypeSnapshot,
  ];
}
