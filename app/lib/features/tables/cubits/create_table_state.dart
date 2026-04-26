part of 'create_table_cubit.dart';

@immutable
final class CreateTableState extends Equatable {
  const CreateTableState({
    this.name = '',
    this.description = '',
    this.hourlyRate = 200,
    this.submitStatus = const RequestInitial(),
    this.deleteStatus = const RequestInitial(),
  });

  final String name;
  final String description;
  final int hourlyRate;
  final RequestStatus<TableModel> submitStatus;
  final RequestStatus<bool> deleteStatus;

  bool get isValid => name.trim().isNotEmpty;

  bool get isLoading => submitStatus is RequestLoading;

  bool get isDeleting => deleteStatus is RequestLoading;

  CreateTableState copyWith({
    String? name,
    String? description,
    int? hourlyRate,
    RequestStatus<TableModel>? submitStatus,
    RequestStatus<bool>? deleteStatus,
  }) => CreateTableState(
    name: name ?? this.name,
    description: description ?? this.description,
    hourlyRate: hourlyRate ?? this.hourlyRate,
    submitStatus: submitStatus ?? this.submitStatus,
    deleteStatus: deleteStatus ?? this.deleteStatus,
  );

  @override
  List<Object?> get props => [name, description, hourlyRate, submitStatus, deleteStatus];
}
