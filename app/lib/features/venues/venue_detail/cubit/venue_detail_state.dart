part of 'venue_detail_cubit.dart';

@immutable
final class VenueDetailState extends Equatable {
  const VenueDetailState({
    this.spots = const RequestInitial(),
    this.deleteStatus = const RequestInitial(),
  });

  final RequestStatus<List<SpotModel>> spots;
  final RequestStatus<bool> deleteStatus;

  bool get isDeleting => deleteStatus.isLoading;

  VenueDetailState copyWith({
    RequestStatus<List<SpotModel>>? spots,
    RequestStatus<bool>? deleteStatus,
  }) {
    return VenueDetailState(
      spots: spots ?? this.spots,
      deleteStatus: deleteStatus ?? this.deleteStatus,
    );
  }

  @override
  List<Object?> get props => [
    spots,
    deleteStatus,
  ];
}
