import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
final class AnalyticsEvent extends Equatable {
  const AnalyticsEvent({
    required this.name,
    this.parameters,
  });

  final String name;
  final Map<String, Object>? parameters;

  @override
  List<Object?> get props => [name, parameters];
}
