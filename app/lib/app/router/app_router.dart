import 'package:auth/auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sport_manager_mobile/app/app.dart';
import 'package:sport_manager_mobile/features/auth/auth.dart';
import 'package:sport_manager_mobile/features/home/home.dart';
import 'package:sport_manager_mobile/features/settings/settings.dart';

const Set<String> _authRoutes = {
  AppRoutes.welcome,
  AppRoutes.login,
  AppRoutes.forgotPassword,
  AppRoutes.role,
  AppRoutes.register,
};

GoRouter appRouter(AuthCubit authCubit, {GlobalKey<NavigatorState>? navigatorKey}) {
  final rootNavigatorKey = navigatorKey ?? GlobalKey<NavigatorState>(debugLabel: 'root');

  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: AppRoutes.init,
    debugLogDiagnostics: kDebugMode,
    refreshListenable: GoRouterAuthListenable(authCubit.stream),
    redirect: (context, state) {
      final authState = authCubit.state;
      final matchedLocation = state.matchedLocation;

      if (authState is AuthInitial || authState is AuthLogoutInProgress) {
        return null;
      }

      final isAuthenticated = authState is AuthAuthenticated;
      final isOnAuthRoute = _authRoutes.contains(matchedLocation);
      final isOnInit = matchedLocation == AppRoutes.init;

      if (isAuthenticated && (isOnAuthRoute || isOnInit)) {
        return AppRoutes.home;
      }

      if (!isAuthenticated && (!isOnAuthRoute || isOnInit)) {
        return AppRoutes.welcome;
      }

      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.init,
        builder: (context, state) => const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
      ),
      GoRoute(
        path: AppRoutes.welcome,
        builder: (context, state) => const WelcomeView(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginView(),
      ),
      GoRoute(
        path: AppRoutes.forgotPassword,
        builder: (context, state) => const ForgotPasswordView(),
      ),
      GoRoute(
        path: AppRoutes.role,
        builder: (context, state) => const RoleSelectView(),
      ),
      GoRoute(
        path: AppRoutes.register,
        redirect: (context, state) => state.extra is UserRole ? null : AppRoutes.role,
        builder: (context, state) => RegisterView(role: state.extra! as UserRole),
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
