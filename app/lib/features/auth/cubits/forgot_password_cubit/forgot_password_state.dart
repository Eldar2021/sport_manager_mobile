part of 'forgot_password_cubit.dart';

final class ForgotPasswordState extends Equatable {
  const ForgotPasswordState({
    this.email = '',
    this.status = const DataInitial(),
  });

  final String email;
  final DataState<void> status;

  bool get isEmailValid => InputValidators.isValidEmail(email);
  bool get isLoading => status.isLoading;
  bool get canSubmit => isEmailValid && !isLoading;

  ForgotPasswordState copyWith({
    String? email,
    DataState<void>? status,
  }) => ForgotPasswordState(
    email: email ?? this.email,
    status: status ?? this.status,
  );

  @override
  List<Object?> get props => [email, status];
}
