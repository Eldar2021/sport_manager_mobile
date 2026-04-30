part of 'venue_detail_cubit.dart';

@immutable
final class VenueDetailState extends Equatable {
  const VenueDetailState({
    this.tables = const RequestInitial(),
    this.deleteStatus = const RequestInitial(),
  });

  final RequestStatus<List<TableModel>> tables;
  final RequestStatus<bool> deleteStatus;

  bool get isDeleting => deleteStatus.isLoading;

  VenueDetailState copyWith({
    RequestStatus<List<TableModel>>? tables,
    RequestStatus<bool>? deleteStatus,
  }) {
    return VenueDetailState(
      tables: tables ?? this.tables,
      deleteStatus: deleteStatus ?? this.deleteStatus,
    );
  }

  @override
  List<Object?> get props => [
    tables,
    deleteStatus,
  ];
}
