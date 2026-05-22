part of 'spot_detail_cubit.dart';

sealed class SpotDetailState extends Equatable {
  const SpotDetailState();
}

@immutable
final class SpotDetailFree extends SpotDetailState {
  const SpotDetailFree({
    required this.spot,
    this.startStatus = const RequestInitial(),
    this.deleteStatus = const RequestInitial(),
  });

  final SpotModel spot;
  final RequestStatus<SessionModel> startStatus;
  final RequestStatus<bool> deleteStatus;

  SpotDetailFree copyWith({
    SpotModel? spot,
    RequestStatus<SessionModel>? startStatus,
    RequestStatus<bool>? deleteStatus,
  }) {
    return SpotDetailFree(
      spot: spot ?? this.spot,
      startStatus: startStatus ?? this.startStatus,
      deleteStatus: deleteStatus ?? this.deleteStatus,
    );
  }

  @override
  List<Object?> get props => [spot, startStatus, deleteStatus];
}

@immutable
final class SpotDetailOccupied extends SpotDetailState {
  const SpotDetailOccupied({
    required this.spot,
    required this.session,
    this.deleteStatus = const RequestInitial(),
  });

  final SpotModel spot;
  final SessionModel session;
  final RequestStatus<bool> deleteStatus;

  SpotDetailOccupied copyWith({
    SpotModel? spot,
    SessionModel? session,
    RequestStatus<bool>? deleteStatus,
  }) {
    return SpotDetailOccupied(
      spot: spot ?? this.spot,
      session: session ?? this.session,
      deleteStatus: deleteStatus ?? this.deleteStatus,
    );
  }

  @override
  List<Object?> get props => [spot, session, deleteStatus];
}
