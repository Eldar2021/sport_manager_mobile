part of 'spot_form_cubit.dart';

@immutable
final class SpotFormState extends Equatable {
  const SpotFormState({
    this.submitStatus = const RequestInitial(),
    this.deleteStatus = const RequestInitial(),
  });

  final RequestStatus<SpotModel> submitStatus;
  final RequestStatus<bool> deleteStatus;

  SpotFormState copyWith({
    RequestStatus<SpotModel>? submitStatus,
    RequestStatus<bool>? deleteStatus,
  }) {
    return SpotFormState(
      submitStatus: submitStatus ?? this.submitStatus,
      deleteStatus: deleteStatus ?? this.deleteStatus,
    );
  }

  @override
  List<Object?> get props => [
    submitStatus,
    deleteStatus,
  ];
}
