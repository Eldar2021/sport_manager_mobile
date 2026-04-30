import 'package:auth/auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sport_manager_mobile/app/app.dart';
import 'package:sport_manager_mobile/features/auth/auth.dart';
import 'package:sport_manager_mobile/l10n/l10n.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

class RoleSelectView extends StatelessWidget {
  const RoleSelectView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.x4,
          vertical: AppSpacing.x4,
        ),
        children: [
          Text(
            context.l10n.authChooseRole,
            style: context.textTheme.headlineLarge?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            context.l10n.authChooseRoleSubtitle,
            style: context.appTextStyles.muted.bodyMedium,
          ),
          const SizedBox(height: AppSpacing.x6),
          RoleCard(
            icon: Icons.business_center_rounded,
            iconBg: context.colors.surfaceContainerLow,
            title: context.l10n.authOwnerTitle,
            subtitle: context.l10n.authOwnerSubtitle,
            onTap: () => context.push(
              AppRoutes.register,
              extra: UserRole.owner,
            ),
          ),
          const SizedBox(height: AppSpacing.x3),
          RoleCard(
            icon: Icons.person_rounded,
            iconBg: context.colors.surfaceContainerLow,
            title: context.l10n.authManagerTitle,
            subtitle: context.l10n.authManagerSubtitle,
            onTap: () => context.push(
              AppRoutes.register,
              extra: UserRole.manager,
            ),
          ),
        ],
      ),
    );
  }
}
