import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'manager_model.g.dart';

@immutable
@JsonSerializable()
final class ManagerModel extends Equatable {
  const ManagerModel({
    required this.id,
    required this.name,
    required this.username,
    this.lastSeenAt,
  });

  factory ManagerModel.fromJson(Map<String, dynamic> json) {
    return _$ManagerModelFromJson(json);
  }

  final String id;
  final String name;
  final String username;
  final DateTime? lastSeenAt;

  Map<String, dynamic> toJson() => _$ManagerModelToJson(this);

  String get avatarChar {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length >= 2 && parts.first.isNotEmpty && parts.last.isNotEmpty) {
      return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    }
    if (name.isNotEmpty) return name[0].toUpperCase();
    return '?';
  }

  @override
  List<Object?> get props => [
    id,
    name,
    username,
    lastSeenAt,
  ];
}
