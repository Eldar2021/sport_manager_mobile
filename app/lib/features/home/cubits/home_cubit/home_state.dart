part of 'home_cubit.dart';

@immutable
final class HomeState extends Equatable {
  const HomeState({
    this.selectedStatus = const RequestInitial(),
    this.justFreedTableIds = const {},
    this.tick = 0,
  });

  final RequestStatus<SelectedVenueModel> selectedStatus;
  final Set<String> justFreedTableIds;
  final int tick;

  VenueModel? get selectedVenue => switch (selectedStatus) {
    RequestSuccess(:final data) => data.venue,
    _ => null,
  };

  List<TableModel> get tables => switch (selectedStatus) {
    RequestSuccess(:final data) => data.tables,
    _ => const [],
  };

  bool get isLoading => selectedStatus is RequestInitial || selectedStatus is RequestLoading;

  HomeState copyWith({
    RequestStatus<SelectedVenueModel>? selectedStatus,
    Set<String>? justFreedTableIds,
    int? tick,
  }) => HomeState(
    selectedStatus: selectedStatus ?? this.selectedStatus,
    justFreedTableIds: justFreedTableIds ?? this.justFreedTableIds,
    tick: tick ?? this.tick,
  );

  @override
  List<Object?> get props => [selectedStatus, justFreedTableIds, tick];
}
