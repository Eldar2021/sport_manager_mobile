import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sport_manager_mobile/app/app.dart';
import 'package:sport_manager_mobile/features/auth/auth.dart';
import 'package:sport_manager_mobile/features/home/home.dart';
import 'package:sport_manager_mobile/features/settings/settings.dart';

class _GoRouterAuthListenable extends ChangeNotifier {
  _GoRouterAuthListenable(Stream<AuthState> stream) {
    _subscription = stream.listen((_) => notifyListeners());
  }

  late final StreamSubscription<AuthState> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

const Set<String> _authRoutes = {
  AppRoutes.welcome,
  AppRoutes.login,
  AppRoutes.forgotPassword,
  AppRoutes.role,
  AppRoutes.registerOwner,
  AppRoutes.registerManager,
};

GoRouter appRouter(AuthCubit authCubit, {GlobalKey<NavigatorState>? navigatorKey}) {
  final rootNavigatorKey = navigatorKey ?? GlobalKey<NavigatorState>(debugLabel: 'root');

  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: authCubit.state is AuthAuthenticated ? AppRoutes.home : AppRoutes.welcome,
    debugLogDiagnostics: kDebugMode,
    refreshListenable: _GoRouterAuthListenable(authCubit.stream),
    redirect: (context, state) {
      final authState = authCubit.state;

      if (authState is AuthInitial || authState is AuthLoading) return null;

      final isAuthenticated = authState is AuthAuthenticated;
      final isOnAuthRoute = _authRoutes.contains(state.matchedLocation);

      if (isAuthenticated && isOnAuthRoute) return AppRoutes.home;
      if (!isAuthenticated && !isOnAuthRoute) return AppRoutes.welcome;
      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.welcome,
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.forgotPassword,
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: AppRoutes.role,
        builder: (context, state) => const RoleSelectScreen(),
      ),
      GoRoute(
        path: AppRoutes.registerOwner,
        builder: (context, state) => const RegisterOwnerScreen(),
      ),
      GoRoute(
        path: AppRoutes.registerManager,
        builder: (context, state) => const RegisterManagerScreen(),
      ),
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: AppRoutes.settings,
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const SettingsView(),
      ),
    ],
  );
}
