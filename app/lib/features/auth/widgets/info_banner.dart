import 'package:flutter/material.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

class InfoBanner extends StatelessWidget {
  const InfoBanner(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.brandAmberLight,
        borderRadius: AppRadius.cardBorderRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.x4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.lock_outline_rounded, color: AppColors.brandAmber),
            const SizedBox(width: AppSpacing.x3),
            Expanded(
              child: Text(
                text,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.brandAmberDark,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
