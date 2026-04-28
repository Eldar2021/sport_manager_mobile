import 'package:flutter/material.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

class AppOutlinedButton extends StatelessWidget {
  const AppOutlinedButton({
    required this.title,
    this.icon,
    this.onTap,
    super.key,
  });

  final VoidCallback? onTap;
  final String title;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          backgroundColor: context.colors.surface,
          foregroundColor: context.colors.onSurfaceVariant,
          side: BorderSide(color: context.colors.outline, style: BorderStyle.values[1]),
          shape: const RoundedRectangleBorder(
            borderRadius: AppRadius.cardBorderRadius,
          ),
        ),
        icon: Icon(icon ?? Icons.add_rounded, color: context.colors.primary),
        label: Text(
          title,
          style: context.textTheme.bodyLarge?.copyWith(color: context.colors.primary),
        ),
      ),
    );
  }
}
