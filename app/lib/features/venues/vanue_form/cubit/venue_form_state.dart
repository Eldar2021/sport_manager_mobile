part of 'venue_form_cubit.dart';

@immutable
final class VenueFormState extends Equatable {
  const VenueFormState({
    this.selectedType,
    this.reqStatus = const RequestInitial(),
    this.deleteStatus = const RequestInitial(),
  });

  final VenueType? selectedType;
  final RequestStatus<VenueModel> reqStatus;
  final RequestStatus<bool> deleteStatus;

  bool get isLoading => reqStatus is RequestLoading;
  bool get isDeleting => deleteStatus is RequestLoading;

  VenueFormState copyWith({
    VenueType? selectedType,
    RequestStatus<VenueModel>? reqStatus,
    RequestStatus<bool>? deleteStatus,
  }) {
    return VenueFormState(
      selectedType: selectedType ?? this.selectedType,
      reqStatus: reqStatus ?? this.reqStatus,
      deleteStatus: deleteStatus ?? this.deleteStatus,
    );
  }

  @override
  List<Object?> get props => [
    selectedType,
    reqStatus,
    deleteStatus,
  ];
}
