import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'insight_action.g.dart';

@JsonEnum()
enum InsightActionType {
  @JsonValue('NONE')
  none,
  @JsonValue('MANAGER_DETAIL')
  managerDetail,
  @JsonValue('TABLE_DETAIL')
  tableDetail,
  @JsonValue('VENUE_DETAIL')
  venueDetail,
  @JsonValue('FORECAST')
  forecast,
}

@immutable
@JsonSerializable()
final class InsightAction extends Equatable {
  const InsightAction({required this.type, this.targetId});

  factory InsightAction.fromJson(Map<String, dynamic> json) {
    return _$InsightActionFromJson(json);
  }

  final InsightActionType type;
  final String? targetId;

  Map<String, dynamic> toJson() => _$InsightActionToJson(this);

  @override
  List<Object?> get props => [
    type,
    targetId,
  ];
}
