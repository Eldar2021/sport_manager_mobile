part of 'table_form_cubit.dart';

@immutable
final class TableFormState extends Equatable {
  const TableFormState({
    this.submitStatus = const RequestInitial(),
    this.deleteStatus = const RequestInitial(),
  });

  final RequestStatus<TableModel> submitStatus;
  final RequestStatus<bool> deleteStatus;

  bool get isLoading => submitStatus is RequestLoading;
  bool get isDeleting => deleteStatus is RequestLoading;

  TableFormState copyWith({
    RequestStatus<TableModel>? submitStatus,
    RequestStatus<bool>? deleteStatus,
  }) {
    return TableFormState(
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
