import 'package:flutter/material.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

class RoleBadge extends StatelessWidget {
  const RoleBadge({
    required this.label,
    required this.color,
    required this.bg,
    required this.icon,
    super.key,
  });

  final String label;
  final Color color;
  final Color bg;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: Icon(icon, color: color, size: 14),
      label: Text(
        label.toUpperCase(),
        style: context.textTheme.bodySmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
      backgroundColor: bg,
      side: BorderSide.none,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x3,
        vertical: AppSpacing.x1,
      ),
    );
  }
}
