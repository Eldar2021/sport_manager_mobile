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
    return Card(
      color: colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.cardBorderRadius,
        side: BorderSide(color: colorScheme.outline),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.all(AppSpacing.x5),
        leading: DecoratedBox(
          decoration: BoxDecoration(
            color: iconBg,
            borderRadius: const BorderRadius.all(Radius.circular(14)),
          ),
          child: SizedBox(
            width: 56,
            height: 56,
            child: Icon(
              icon,
              size: 28,
              color: colorScheme.primary,
            ),
          ),
        ),
        title: Text(title),
        subtitle: Text(
          subtitle,
          style: textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        trailing: const Icon(Icons.chevron_right_rounded),
      ),
    );
  }
}
