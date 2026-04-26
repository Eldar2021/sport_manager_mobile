import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sport_manager_mobile/app/app.dart';
import 'package:sport_manager_mobile/core/core.dart';
import 'package:sport_manager_mobile/features/auth/auth.dart';
import 'package:sport_manager_mobile/features/home/home.dart';
import 'package:sport_manager_mobile/features/profile/profile.dart';
import 'package:sport_manager_mobile/features/report/report.dart';
import 'package:sport_manager_mobile/features/tables/tables.dart';
import 'package:sport_manager_mobile/features/venues/venues.dart';
import 'package:tables/tables.dart';

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
    initialLocation: AppRoutes.init,
    debugLogDiagnostics: kDebugMode,
    refreshListenable: GoRouterAuthListenable(authCubit.stream),
    redirect: (context, state) {
      final authState = authCubit.state;
      final matchedLocation = state.matchedLocation;

      if (authState is AuthInitial || authState is AuthLoading) {
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
        path: AppRoutes.createVenue,
        builder: (context, _) => const CreateVenueScreen(),
      ),

      GoRoute(
        path: AppRoutes.createTable,
        builder: (_, state) => CreateTableScreen(
          venueId: state.extra as String? ?? '',
        ),
      ),

      GoRoute(
        path: AppRoutes.editTable,
        builder: (_, state) {
          final extra = state.extra! as (String, TableModel);
          return CreateTableScreen(venueId: extra.$1, initialTable: extra.$2);
        },
      ),

      StatefulShellRoute.indexedStack(
        builder: (_, _, shell) => MainShell(navigationShell: shell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.home,
                builder: (_, _) => const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.report,
                builder: (_, _) => const ReportScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.profile,
                builder: (_, _) => const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
