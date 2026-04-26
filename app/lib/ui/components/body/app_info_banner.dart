import 'package:flutter/material.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

class AppInfoBanner extends StatelessWidget {
  const AppInfoBanner({
    required this.text,
    super.key,
    this.icon = Icons.auto_awesome,
    this.color = AppColors.brandAmber,
    this.backgroundColor = AppColors.brandAmberLight,
  });

  final String text;
  final IconData icon;
  final Color color;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: AppRadius.cardBorderRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.x4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 16),
            const SizedBox(width: AppSpacing.x2),
            Expanded(
              child: Text(
                text,
                style: AppTypography.body.copyWith(color: color),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
