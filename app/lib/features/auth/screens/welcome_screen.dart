import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sport_manager_mobile/app/app.dart';
import 'package:sport_manager_mobile/features/auth/auth.dart';
import 'package:sport_manager_mobile/l10n/l10n.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.x6,
            vertical: AppSpacing.x4,
          ),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const AppLogo(),
                    const SizedBox(height: AppSpacing.x6),
                    Text(
                      'TableFlow',
                      style: textTheme.displaySmall,
                    ),
                    const SizedBox(height: AppSpacing.x2),
                    Text(
                      l10n.authTagline,
                      style: textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.x8),
                    const PoolTableIllustration(),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  FilledButton(
                    onPressed: () => context.push(AppRoutes.login),
                    child: Text(l10n.authSignIn),
                  ),
                  const SizedBox(height: AppSpacing.x3),
                  OutlinedButton(
                    onPressed: () => context.push(AppRoutes.role),
                    child: Text(l10n.authSignUp),
                  ),
                  const SizedBox(height: AppSpacing.x4),
                  const LanguageSwitcher(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
