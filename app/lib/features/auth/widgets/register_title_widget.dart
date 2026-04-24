import 'package:flutter/material.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

class RegisterTitleWidget extends StatelessWidget {
  const RegisterTitleWidget({
    required this.title,
    required this.badge,
    required this.icon,
    required this.colorBadge,
    super.key,
  });

  final String title;
  final String badge;
  final IconData icon;
  final Color colorBadge;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x6, vertical: AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: AppSpacing.x3),
          _RoleBadge(
            label: badge,
            color: colorBadge,
            bg: colorBadge.withValues(alpha: 0.12),
            icon: icon,
          ),
        ],
      ),
    );
  }
}

class _RoleBadge extends StatelessWidget {
  const _RoleBadge({
    required this.label,
    required this.color,
    required this.bg,
    required this.icon,
  });

  final String label;
  final Color color;
  final Color bg;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x3, vertical: AppSpacing.x1),
      decoration: BoxDecoration(color: bg, borderRadius: AppRadius.chipBorderRadius),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 14),
          const SizedBox(width: AppSpacing.x1),
          Text(
            label.toUpperCase(),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
