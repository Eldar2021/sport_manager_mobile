import 'package:flutter/material.dart';
import 'package:sport_manager_mobile/l10n/l10n.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

class SubscriptionErrorView extends StatelessWidget {
  const SubscriptionErrorView({required this.onRetry, super.key});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(AppSpacing.x4),
      children: [
        const SizedBox(height: AppSpacing.x6),
        Icon(Icons.error_outline, size: 56, color: context.colors.error),
        const SizedBox(height: AppSpacing.x3),
        Text(
          context.l10n.subscriptionErrorTitle,
          style: context.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.x2),
        Text(
          context.l10n.subscriptionErrorSubtitle,
          style: context.appTextStyles.muted.bodyMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.x4),
        Center(
          child: AppButton(
            variant: AppButtonVariant.outline,
            size: AppButtonSize.medium,
            expand: false,
            onPressed: onRetry,
            child: Text(context.l10n.generalRetry),
          ),
        ),
      ],
    );
  }
}
