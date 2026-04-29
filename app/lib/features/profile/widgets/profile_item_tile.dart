import 'package:flutter/material.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

class ProfileItemTile extends StatelessWidget {
  const ProfileItemTile({
    required this.icon,
    required this.iconBgColor,
    required this.title,
    required this.subtitle,
    this.onTap,
    super.key,
  });

  final Widget icon;
  final Color iconBgColor;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: DecoratedBox(
        decoration: BoxDecoration(
          color: iconBgColor,
          borderRadius: BorderRadius.circular(AppSpacing.x2),
        ),
        child: SizedBox(
          height: AppSpacing.x10,
          width: AppSpacing.x10,
          child: icon,
        ),
      ),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: AppSpacing.x4,
      ),
    );
  }
}
