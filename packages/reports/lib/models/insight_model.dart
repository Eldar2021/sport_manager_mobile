import 'package:core/core.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:reports/models/insight_action.dart';
import 'package:reports/models/insight_severity.dart';

part 'insight_model.g.dart';

/// `BaseMessage` lives in `core` and isn't `@JsonSerializable`, so reports
/// transports localized copy as a raw `{en, ru, ky}` map and exposes a
/// typed getter on top.
@immutable
@JsonSerializable()
final class InsightModel extends Equatable {
  const InsightModel({
    required this.id,
    required this.severity,
    required this.title,
    required this.body,
    required this.createdAt,
    required this.acknowledged,
    this.action,
  });

  factory InsightModel.fromJson(Map<String, dynamic> json) {
    return _$InsightModelFromJson(json);
  }

  final String id;
  final InsightSeverity severity;
  final Map<String, String> title;
  final Map<String, String> body;
  final DateTime createdAt;
  final bool acknowledged;
  final InsightAction? action;

  BaseMessage get titleMessage => _toMessage(title);
  BaseMessage get bodyMessage => _toMessage(body);

  static BaseMessage _toMessage(Map<String, String> raw) {
    return BaseMessage(
      en: raw['en'] ?? raw['EN'] ?? '',
      ru: raw['ru'] ?? raw['RU'] ?? '',
      ky: raw['ky'] ?? raw['KY'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => _$InsightModelToJson(this);

  @override
  List<Object?> get props => [
    id,
    severity,
    title,
    body,
    createdAt,
    acknowledged,
    action,
  ];
}
