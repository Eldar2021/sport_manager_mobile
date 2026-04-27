part of 'venue_form_cubit.dart';

@immutable
final class VenueFormState extends Equatable {
  const VenueFormState({
    this.reqStatus = const RequestInitial(),
    this.deleteStatus = const RequestInitial(),
  });

  final RequestStatus<VenueModel> reqStatus;
  final RequestStatus<bool> deleteStatus;

  bool get isLoading => reqStatus is RequestLoading;
  bool get isDeleting => deleteStatus is RequestLoading;

  VenueFormState copyWith({
    String? name,
    String? number,
    RequestStatus<VenueModel>? reqStatus,
    RequestStatus<bool>? deleteStatus,
  }) => VenueFormState(
    reqStatus: reqStatus ?? this.reqStatus,
    deleteStatus: deleteStatus ?? this.deleteStatus,
  );

  @override
  List<Object?> get props => [reqStatus, deleteStatus];
}
