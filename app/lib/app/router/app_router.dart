import 'package:auth/auth.dart';
import 'package:facility/facility.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sport_manager_mobile/app/app.dart';
import 'package:sport_manager_mobile/features/auth/auth.dart';
import 'package:sport_manager_mobile/features/home/home.dart';
import 'package:sport_manager_mobile/features/main/main.dart';
import 'package:sport_manager_mobile/features/managers/managers.dart';
import 'package:sport_manager_mobile/features/profile/profile.dart';
import 'package:sport_manager_mobile/features/report/report.dart';
import 'package:sport_manager_mobile/features/tables/tables.dart';
import 'package:sport_manager_mobile/features/venues/venues.dart';

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
        path: AppRoutes.updatePassword,
        builder: (context, state) => const UpdatePasswordView(),
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
        path: AppRoutes.venueForm,
        builder: (context, state) => VenueFormView(venue: state.extra as VenueModel?),
      ),

      GoRoute(
        path: AppRoutes.venuesList,
        builder: (_, _) => const VenuesListView(),
      ),

      GoRoute(
        path: AppRoutes.venueDetail,
        redirect: (_, state) => state.extra is VenueModel ? null : AppRoutes.venuesList,
        builder: (_, state) => VenueDetailView(venue: state.extra! as VenueModel),
      ),

      GoRoute(
        path: AppRoutes.tableForm,
        builder: (_, state) => TableFormView(state.extra! as TableFormExtra),
      ),

      GoRoute(
        path: AppRoutes.managers,
        builder: (_, _) => const ManagersView(),
      ),

      StatefulShellRoute.indexedStack(
        builder: (_, _, shell) => MainView(shell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.home,
                builder: (_, _) => const HomeView(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.report,
                builder: (_, _) => const ReportView(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.profile,
                builder: (_, _) => const ProfileView(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
