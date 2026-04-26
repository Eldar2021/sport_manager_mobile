import 'package:auth/auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sport_manager_mobile/features/auth/cubits/auth_cubit/auth_cubit.dart';

class RoleGuard extends StatelessWidget {
  const RoleGuard({
    required this.roles,
    required this.child,
    this.fallback = const SizedBox.shrink(),
    super.key,
  });

  final Set<UserRole> roles;
  final Widget child;
  final Widget fallback;

  @override
  Widget build(BuildContext context) {
    final role = context.select<AuthCubit, UserRole?>((c) => c.state.role);
    return roles.contains(role) ? child : fallback;
  }
}
