import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:sessions/models/session_model.dart';

part 'sessions_response.g.dart';

@immutable
@JsonSerializable()
final class SessionsResponse extends Equatable {
  const SessionsResponse({
    required this.items,
    required this.total,
    required this.page,
    required this.limit,
  });

  factory SessionsResponse.fromJson(Map<String, dynamic> json) {
    return _$SessionsResponseFromJson(json);
  }

  final List<SessionModel> items;
  final int total;
  final int page;
  final int limit;

  Map<String, dynamic> toJson() {
    return _$SessionsResponseToJson(this);
  }

  @override
  List<Object?> get props => [
    items,
    total,
    page,
    limit,
  ];
}
