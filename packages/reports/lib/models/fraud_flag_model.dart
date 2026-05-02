import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:reports/models/fraud_flag_code.dart';
import 'package:reports/models/insight_severity.dart';

part 'fraud_flag_model.g.dart';

@immutable
@JsonSerializable()
final class FraudFlagModel extends Equatable {
  const FraudFlagModel({
    required this.code,
    required this.severity,
    required this.value,
    required this.benchmark,
  });

  factory FraudFlagModel.fromJson(Map<String, dynamic> json) {
    return _$FraudFlagModelFromJson(json);
  }

  final FraudFlagCode code;
  final InsightSeverity severity;

  /// The measured raw value (e.g. cancel rate as a decimal `0.084`).
  final double value;

  /// The owner-team benchmark for this metric (e.g. `0.030`). UI shows the
  /// "× over average" multiplier from these two.
  final double benchmark;

  /// Multiplier vs benchmark (`value / benchmark`). Caps at 99 to keep the
  /// UI bounded. `null` when benchmark is zero.
  double? get multiplier {
    if (benchmark == 0) return null;
    final m = value / benchmark;
    return m.isFinite ? m.clamp(0, 99).toDouble() : null;
  }

  Map<String, dynamic> toJson() => _$FraudFlagModelToJson(this);

  @override
  List<Object?> get props => [
    code,
    severity,
    value,
    benchmark,
  ];
}
