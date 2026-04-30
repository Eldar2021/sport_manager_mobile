part of 'managers_cubit.dart';

@immutable
final class ManagersState extends Equatable {
  const ManagersState({
    this.inviteCode = const RequestInitial(),
    this.managers = const RequestInitial(),
    this.deletingId,
  });

  final RequestStatus<InviteCodeModel> inviteCode;
  final RequestStatus<List<ManagerModel>> managers;
  final String? deletingId;

  ManagersState copyWith({
    RequestStatus<InviteCodeModel>? inviteCode,
    RequestStatus<List<ManagerModel>>? managers,
    String? deletingId,
    bool clearDeletingId = false,
  }) => ManagersState(
    inviteCode: inviteCode ?? this.inviteCode,
    managers: managers ?? this.managers,
    deletingId: clearDeletingId ? null : (deletingId ?? this.deletingId),
  );

  @override
  List<Object?> get props => [
    inviteCode,
    managers,
    deletingId,
  ];
}
