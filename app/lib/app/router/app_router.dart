import 'package:auth/auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:sport_manager_mobile/app/app.dart';
import 'package:sport_manager_mobile/features/auth/auth.dart';
import 'package:sport_manager_mobile/features/home/home.dart';
import 'package:sport_manager_mobile/features/settings/settings.dart';

const Set<String> _authRoutes = {
  AppRoutes.welcome,
  AppRoutes.login,
  AppRoutes.role,
  AppRoutes.registerOwner,
  AppRoutes.registerManager,
};

GoRouter appRouter({GlobalKey<NavigatorState>? navigatorKey}) {
  final rootNavigatorKey = navigatorKey ?? GlobalKey<NavigatorState>(debugLabel: 'root');

  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: AppRoutes.welcome,
    debugLogDiagnostics: kDebugMode,
    redirect: (context, state) {
      final isAuthenticated = GetIt.I<AuthRepository>().getToken() != null;
      if (isAuthenticated && _authRoutes.contains(state.matchedLocation)) {
        return AppRoutes.home;
      }
      if (!isAuthenticated && !_authRoutes.contains(state.matchedLocation)) {
        return AppRoutes.welcome;
      }
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
