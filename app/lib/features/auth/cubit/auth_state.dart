part of 'auth_cubit.dart';

@immutable
sealed class AuthState extends Equatable {
  const AuthState();

  bool get isOwner => this is AuthAuthenticated && (this as AuthAuthenticated).role == UserRole.owner;
  bool get isManager => this is AuthAuthenticated && (this as AuthAuthenticated).role == UserRole.manager;
  UserRole? get role => this is AuthAuthenticated ? (this as AuthAuthenticated).role : null;
}

@immutable
final class AuthInitial extends AuthState {
  const AuthInitial();

  @override
  List<Object?> get props => [];
}

@immutable
final class AuthLogoutInProgress extends AuthState {
  const AuthLogoutInProgress();

  @override
  List<Object?> get props => [];
}

@immutable
final class AuthAuthenticated extends AuthState {
  const AuthAuthenticated({required this.user});

  final UserModel user;

  @override
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
