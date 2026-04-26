import 'package:flutter/material.dart';
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
      builder: (_) => AppDestructiveSheet(
        icon: icon,
        title: title,
        subtitle: subtitle,
        confirmLabel: confirmLabel,
        onConfirm: onConfirm,
      ),
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
          Container(
            width: 56,
            height: 56,
            decoration: const BoxDecoration(
              color: AppColors.dangerLight,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.dangerRed, size: 24),
          ),
          const SizedBox(height: AppSpacing.x4),
          Text(title, style: AppTypography.h2, textAlign: TextAlign.center),
          const SizedBox(height: AppSpacing.x2),
          Text(
            subtitle,
            style: AppTypography.body.copyWith(color: AppColors.ink500),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.x6),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () {
                Navigator.pop(context);
                onConfirm();
              },
              style: FilledButton.styleFrom(backgroundColor: AppColors.dangerRed),
              child: Text(confirmLabel),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              l10n.cancel,
              style: AppTypography.body.copyWith(color: AppColors.brandAmber),
            ),
          ),
        ],
      ),
    );
  }
}
