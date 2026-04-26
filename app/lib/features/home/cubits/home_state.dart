part of 'home_cubit.dart';

@immutable
final class HomeState extends Equatable {
  const HomeState({
    this.venuesStatus = const RequestInitial(),
    this.selectedVenue,
    this.tablesStatus = const RequestInitial(),
    this.activeSessions = const {},
    this.justFreedTableIds = const {},
    this.tick = 0,
  });

  final RequestStatus<List<VenueModel>> venuesStatus;
  final VenueModel? selectedVenue;
  final RequestStatus<List<TableModel>> tablesStatus;
  final Map<String, SessionModel> activeSessions;
  final Set<String> justFreedTableIds;
  final int tick;

  List<VenueModel> get venues => venuesStatus is RequestSuccess<List<VenueModel>>
      ? (venuesStatus as RequestSuccess<List<VenueModel>>).data
      : const [];

  List<TableModel> get tables => tablesStatus is RequestSuccess<List<TableModel>>
      ? (tablesStatus as RequestSuccess<List<TableModel>>).data
      : const [];

  bool get isInitialLoading =>
      venuesStatus is RequestInitial || venuesStatus is RequestLoading;

  bool get isTablesLoading =>
      tablesStatus is RequestInitial || tablesStatus is RequestLoading;

  HomeState copyWith({
    RequestStatus<List<VenueModel>>? venuesStatus,
    VenueModel? selectedVenue,
    RequestStatus<List<TableModel>>? tablesStatus,
    Map<String, SessionModel>? activeSessions,
    Set<String>? justFreedTableIds,
    int? tick,
  }) => HomeState(
    venuesStatus: venuesStatus ?? this.venuesStatus,
    selectedVenue: selectedVenue ?? this.selectedVenue,
    tablesStatus: tablesStatus ?? this.tablesStatus,
    activeSessions: activeSessions ?? this.activeSessions,
    justFreedTableIds: justFreedTableIds ?? this.justFreedTableIds,
    tick: tick ?? this.tick,
  );

  @override
  List<Object?> get props => [
    venuesStatus,
    selectedVenue,
    tablesStatus,
    activeSessions,
    justFreedTableIds,
    tick,
  ];
}
