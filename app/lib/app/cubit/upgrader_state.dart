part of 'upgrader_cubit.dart';

@immutable
final class UpgraderState extends Equatable {
  const UpgraderState({this.status = UpgradeStatusEnum.none});

  final UpgradeStatusEnum status;

  UpgraderState copyWith({UpgradeStatusEnum? status}) {
    return UpgraderState(status: status ?? this.status);
  }

  @override
  List<Object?> get props => [status];
}
