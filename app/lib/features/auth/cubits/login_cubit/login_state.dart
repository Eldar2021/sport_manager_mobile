part of 'login_cubit.dart';

final class LoginState extends Equatable {
  const LoginState({
    this.username = '',
    this.password = '',
    this.status = const DataInitial(),
  });

  final String username;
  final String password;
  final DataState<void> status;

  bool get isLoading => status.isLoading;
  bool get isSuccess => status.isSuccess;
  bool get isFailure => status.isFailure;

  bool get isUsernameValid => InputValidators.isValidUsername(username);
  bool get isPasswordValid => InputValidators.isValidPassword(password);
  bool get canSubmit => isUsernameValid && isPasswordValid && !isLoading;

  LoginState copyWith({
    String? username,
    String? password,
    DataState<void>? status,
  }) => LoginState(
    username: username ?? this.username,
    password: password ?? this.password,
    status: status ?? this.status,
  );

  @override
  List<Object?> get props => [username, password, status];
}
