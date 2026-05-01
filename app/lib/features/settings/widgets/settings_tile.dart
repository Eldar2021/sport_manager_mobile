import 'package:flutter/material.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

class SettingsTile extends StatelessWidget {
  const SettingsTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.value,
    required this.onTap,
    super.key,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: DecoratedBox(
        decoration: BoxDecoration(
          color: iconColor.withValues(alpha: AppOpacity.tint),
          borderRadius: BorderRadius.circular(AppSpacing.x2),
        ),
        child: SizedBox(
          height: AppSpacing.x10,
          width: AppSpacing.x10,
          child: Icon(icon, color: iconColor),
        ),
      ),
      title: Text(title),
      subtitle: Text(
        value,
        style: context.appTextStyles.muted.bodySmall,
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: AppSpacing.x4,
      ),
    );
  }
}
