part of 'home_cubit.dart';

sealed class HomeState extends Equatable {
  const HomeState();
}

class HomeLoading extends HomeState {
  const HomeLoading();

  @override
  List<Object?> get props => [];
}

class HomeNoVenue extends HomeState {
  const HomeNoVenue();

  @override
  List<Object?> get props => [];
}

class HomeNoTables extends HomeState {
  const HomeNoTables(this.venue);

  final VenueModel venue;

  @override
  List<Object?> get props => [venue];
}

class HomeLoaded extends HomeState {
  const HomeLoaded({
    required this.venue,
    required this.tables,
  });

  final VenueModel venue;
  final List<TableModel> tables;

  @override
  List<Object?> get props => [venue, tables];
}

class HomeFailure extends HomeState {
  const HomeFailure(this.exception);
  final Object exception;

  @override
  List<Object?> get props => [exception];
}
