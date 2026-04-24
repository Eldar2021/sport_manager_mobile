import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sport_manager_mobile/app/app.dart';
import 'package:sport_manager_mobile/features/auth/auth.dart';
import 'package:sport_manager_mobile/l10n/l10n.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

class RoleSelectScreen extends StatelessWidget {
  const RoleSelectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppSpacing.x4),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.x2),
              child: BackBtn(),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.x6,
                vertical: AppSpacing.x4,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.authChooseRole,
                    style: textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: AppSpacing.x1),
                  Text(
                    l10n.authChooseRoleSubtitle,
                    style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.x6),
                child: Column(
                  children: [
                    RoleCard(
                      icon: Icons.business_center_rounded,
                      iconBg: colorScheme.surfaceContainerLow,
                      title: l10n.authOwnerTitle,
                      subtitle: l10n.authOwnerSubtitle,
                      onTap: () => context.push(AppRoutes.registerOwner),
                    ),
                    const SizedBox(height: AppSpacing.x3),
                    RoleCard(
                      icon: Icons.person_rounded,
                      iconBg: colorScheme.surfaceContainerLow,
                      title: l10n.authManagerTitle,
                      subtitle: l10n.authManagerSubtitle,
                      onTap: () => context.push(AppRoutes.registerManager),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
