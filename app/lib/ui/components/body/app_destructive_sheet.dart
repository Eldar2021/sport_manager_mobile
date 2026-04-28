import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sport_manager_mobile/l10n/l10n.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

class AppDestructiveSheet extends StatelessWidget {
  const AppDestructiveSheet({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.confirmLabel,
    required this.onConfirm,
    super.key,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String confirmLabel;
  final VoidCallback onConfirm;

  static Future<void> show(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required String confirmLabel,
    required VoidCallback onConfirm,
  }) {
    return showModalBottomSheet(
      context: context,
      builder: (_) {
        return AppDestructiveSheet(
          icon: icon,
          title: title,
          subtitle: subtitle,
          confirmLabel: confirmLabel,
          onConfirm: onConfirm,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.x6,
        AppSpacing.x6,
        AppSpacing.x6,
        AppSpacing.x8,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 56,
            height: 56,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: context.colors.errorContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: context.colors.error,
                size: 24,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.x4),
          Text(
            title,
            style: context.textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.x2),
          Text(
            subtitle,
            style: context.textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.x6),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () {
                context.pop();
                onConfirm();
              },
              style: FilledButton.styleFrom(
                backgroundColor: context.colors.error,
              ),
              child: Text(confirmLabel),
            ),
          ),
          const SizedBox(height: AppSpacing.x5),
          TextButton(
            onPressed: () => context.pop(),
            child: Text(
              l10n.cancel,
              style: context.textTheme.bodyMedium?.copyWith(
                color: context.colors.primary,
              ),
            ),
          ),
          SizedBox(height: AppSpacing.bottom(context)),
        ],
      ),
    );
  }
}
