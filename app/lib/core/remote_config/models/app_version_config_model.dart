import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:sport_manager_mobile/core/core.dart';

@immutable
final class AppVersionConfigModel extends Equatable {
  const AppVersionConfigModel({
    required this.android,
    required this.ios,
  });

  factory AppVersionConfigModel.fromJson(Map<String, dynamic> json) {
    return AppVersionConfigModel(
      android: PlatformVersionModel.fromJson(json['android'] as Map<String, dynamic>),
      ios: PlatformVersionModel.fromJson(json['ios'] as Map<String, dynamic>),
    );
  }

  final PlatformVersionModel android;
  final PlatformVersionModel ios;

  @override
  List<Object?> get props => [
    android,
    ios,
  ];
}
