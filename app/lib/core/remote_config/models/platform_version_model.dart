import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
final class PlatformVersionModel extends Equatable {
  const PlatformVersionModel({
    required this.requiredBuildNumber,
    required this.recommendedBuildNumber,
  });

  factory PlatformVersionModel.fromJson(Map<String, dynamic> json) => PlatformVersionModel(
    requiredBuildNumber: json['requiredBuildNumber'] as int,
    recommendedBuildNumber: json['recommendedBuildNumber'] as int,
  );

  final int requiredBuildNumber;
  final int recommendedBuildNumber;

  @override
  List<Object?> get props => [requiredBuildNumber, recommendedBuildNumber];
}
