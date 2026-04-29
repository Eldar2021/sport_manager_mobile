import 'package:flutter/material.dart';
import 'package:sport_manager_mobile/l10n/l10n.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

class ProfileErrorView extends StatelessWidget {
  const ProfileErrorView({required this.onRetry, super.key});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: context.colors.surface,
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.x6,
          vertical: AppSpacing.x8,
        ),
        child: Column(
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                color: context.colors.errorContainer,
                shape: BoxShape.circle,
              ),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.x4),
                child: Icon(
                  Icons.cloud_off_rounded,
                  size: AppSpacing.x8,
                  color: context.colors.error,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.x4),
            Text(
              context.l10n.profileErrorTitle,
              textAlign: TextAlign.center,
              style: context.textTheme.titleMedium,
            ),
            const SizedBox(height: AppSpacing.x2),
            Text(
              context.l10n.profileErrorSubtitle,
              textAlign: TextAlign.center,
              style: context.appTextStyles.muted.bodyMedium,
            ),
            const SizedBox(height: AppSpacing.x5),
            AppButton(
              variant: AppButtonVariant.secondary,
              size: AppButtonSize.medium,
              expand: false,
              leading: const Icon(Icons.refresh_rounded, size: AppSpacing.x5),
              onPressed: onRetry,
              child: Text(context.l10n.generalRetry),
            ),
          ],
        ),
      ),
    );
  }
}
