import 'package:auth/auth.dart';
import 'package:flutter/material.dart';
import 'package:sport_manager_mobile/l10n/l10n.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

class UserProfileCard extends StatelessWidget {
  const UserProfileCard(this.user, {super.key});

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: context.colors.surface,
      margin: EdgeInsets.zero,
      child: ListTile(
        leading: CircleAvatar(
          radius: AppSpacing.x7,
          backgroundColor: context.colors.primary,
          child: Text(
            user.avatarChar,
            style: context.textTheme.titleLarge?.copyWith(
              color: context.colors.onPrimary,
              letterSpacing: -2,
            ),
          ),
        ),
        title: Text(user.name),
        subtitle: Align(
          alignment: Alignment.centerLeft,
          child: user.role == UserRole.owner
              ? RoleBadge(
                  label: context.l10n.authOwnerBadge,
                  color: context.colors.primary,
                  icon: Icons.business_center_rounded,
                )
              : RoleBadge(
                  label: context.l10n.authManagerBadge,
                  color: context.appColors.success,
                  icon: Icons.badge_outlined,
                ),
        ),
      ),
    );
  }
}
