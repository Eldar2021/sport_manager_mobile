part of 'home_cubit.dart';

sealed class HomeState extends Equatable {
  const HomeState();
}

final class HomeLoading extends HomeState {
  const HomeLoading();

  @override
  List<Object?> get props => [];
}

final class HomeNoVenue extends HomeState {
  const HomeNoVenue();

  @override
  List<Object?> get props => [];
}

final class HomeNoSpots extends HomeState {
  const HomeNoSpots(this.venue);

  final VenueModel venue;

  @override
  List<Object?> get props => [venue];
}

final class HomeLoaded extends HomeState {
  const HomeLoaded({
    required this.venue,
    required this.spots,
  });

  final VenueModel venue;
  final List<SpotModel> spots;

  @override
  List<Object?> get props => [venue, spots];
}

final class HomeFailure extends HomeState {
  const HomeFailure(this.exception);
  final Object exception;

  @override
  List<Object?> get props => [exception];
}
