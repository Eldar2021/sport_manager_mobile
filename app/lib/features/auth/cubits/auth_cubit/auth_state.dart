part of 'auth_cubit.dart';

@immutable
sealed class AuthState extends Equatable {
  const AuthState();
}

@immutable
final class AuthInitial extends AuthState {
  const AuthInitial();

  @override
  List<Object?> get props => [];
}

@immutable
final class AuthLoading extends AuthState {
  const AuthLoading();

  @override
  List<Object?> get props => [];
}

@immutable
final class AuthAuthenticated extends AuthState {
  const AuthAuthenticated({required this.user});

  final UserModel user;

  UserRole get role => user.role;

  @override
  List<Object?> get props => [user];
}

@immutable
final class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();

  @override
  List<Object?> get props => [];
}

@immutable
final class AuthError extends AuthState {
  const AuthError({required this.exception});

  final Object exception;

  @override
  List<Object?> get props => [exception];
}
