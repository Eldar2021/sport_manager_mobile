import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sport_manager_mobile/app/app.dart';
import 'package:sport_manager_mobile/features/home/home.dart';
import 'package:sport_manager_mobile/features/settings/settings.dart';

/// Creates the application [GoRouter].
GoRouter appRouter({GlobalKey<NavigatorState>? navigatorKey}) {
  final rootNavigatorKey = navigatorKey ?? GlobalKey<NavigatorState>(debugLabel: 'root');

  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: AppRoutes.home,
    debugLogDiagnostics: true,
    routes: [
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
