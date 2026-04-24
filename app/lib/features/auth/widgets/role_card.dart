import 'package:flutter/material.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

class RoleCard extends StatelessWidget {
  const RoleCard({
    required this.icon,
    required this.iconBg,
    required this.title,
    required this.subtitle,
    required this.onTap,
    super.key,
  });

  final IconData icon;
  final Color iconBg;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: colorScheme.surface,
      borderRadius: AppRadius.cardBorderRadius,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.cardBorderRadius,
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.x5),
          decoration: BoxDecoration(
            borderRadius: AppRadius.cardBorderRadius,
            border: Border.all(color: colorScheme.outline),
          ),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: const BorderRadius.all(Radius.circular(14)),
                ),
                child: Icon(icon, size: 28, color: colorScheme.primary),
              ),
              const SizedBox(width: AppSpacing.x4),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      subtitle,
                      style: textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.x2),
              Icon(Icons.chevron_right_rounded, color: colorScheme.onSurfaceVariant),
            ],
          ),
        ),
      ),
    );
  }
}
