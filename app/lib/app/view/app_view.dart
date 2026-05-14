import 'package:auth/auth.dart';
import 'package:core/core.dart';
import 'package:facility/facility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:sport_manager_mobile/app/app.dart';
import 'package:sport_manager_mobile/core/core.dart';
import 'package:sport_manager_mobile/env.dart';
import 'package:sport_manager_mobile/features/auth/auth.dart';
import 'package:sport_manager_mobile/features/home/home.dart';
import 'package:sport_manager_mobile/features/profile/profile.dart';
import 'package:sport_manager_mobile/features/settings/settings.dart';
import 'package:sport_manager_mobile/features/subscription/subscription.dart';
import 'package:sport_manager_mobile/l10n/l10n.dart';
import 'package:sport_manager_mobile/ui/ui.dart';
import 'package:storage_client/storage_client.dart';
import 'package:subscription/subscription.dart';

class MyAppWrapper extends StatelessWidget {
  const MyAppWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => UpgraderCubit(
            GetIt.I<RemoteConfigRepository>(),
          )..init(),
        ),
        BlocProvider(
          create: (_) => AuthCubit(
            GetIt.I<AuthRepository>(),
          )..checkAuthStatus(),
        ),
        BlocProvider(
          create: (_) => SettingsCubit(
            GetIt.I<PreferencesStorage>(),
          )..init(),
        ),
        BlocProvider(
          create: (_) => SubscriptionCubit(
            GetIt.I<SubscriptionRepository>(),
          ),
        ),
        BlocProvider(
          create: (_) => HomeCubit(
            GetIt.I<FacilityRepository>(),
          ),
        ),
        BlocProvider(
          create: (_) => ProfileCubit(
            GetIt.I<AuthRepository>(),
          ),
        ),
      ],
      child: BlocListener<AuthCubit, AuthState>(
        listenWhen: (prev, next) => prev.runtimeType != next.runtimeType,
        listener: _onAuthChange,
        child: const MyApp(),
      ),
    );
  }

  static void _onAuthChange(BuildContext context, AuthState authState) {
    final cubit = context.read<SubscriptionCubit>();
    if (authState is AuthAuthenticated && authState.role == UserRole.owner) {
      cubit.loadSummary();
    } else if (authState is AuthUnauthenticated) {
      cubit.clear();
      context.read<ProfileCubit>().clearState();
    }
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final GoRouter _router;
  late final GlobalKey<NavigatorState> _navigatorKey;

  @override
  void initState() {
    super.initState();
    _navigatorKey = GlobalKey<NavigatorState>();
    _router = appRouter(
      context.read<AuthCubit>(),
      navigatorKey: _navigatorKey,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UpgraderCubit, UpgraderState>(
      listenWhen: (prev, next) => next.status != UpgradeStatusEnum.none && prev.status != next.status,
      listener: (_, state) {
        final navCtx = _navigatorKey.currentContext;
        if (navCtx == null) return;
        UpgraderDialog.show(
          navCtx,
          state.status,
          onDismiss: context.read<UpgraderCubit>().dismiss,
        );
      },
      child: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, settings) {
          return MaterialApp.router(
            title: 'Sport Manager',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: settings.themeMode,
            locale: settings.locale,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizationHelper.locales,
            routerConfig: _router,
            builder: (context, child) {
              final wrapped = GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
                child: child,
              );
              if (!Env.isDev) return wrapped;
              return Stack(
                children: [
                  Positioned.fill(child: wrapped),
                  TalkerDevOverlay(_navigatorKey),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
