part of 'create_venue_cubit.dart';

@immutable
final class CreateVenueState extends Equatable {
  const CreateVenueState({
    this.name = '',
    this.number = '',
    this.submitStatus = const RequestInitial(),
  });

  final String name;
  final String number;
  final RequestStatus<VenueModel> submitStatus;

  bool get isValid => name.trim().isNotEmpty;

  bool get isLoading => submitStatus is RequestLoading;

  CreateVenueState copyWith({
    String? name,
    String? number,
    RequestStatus<VenueModel>? submitStatus,
  }) => CreateVenueState(
    name: name ?? this.name,
    number: number ?? this.number,
    submitStatus: submitStatus ?? this.submitStatus,
  );

  @override
  List<Object?> get props => [name, number, submitStatus];
}
