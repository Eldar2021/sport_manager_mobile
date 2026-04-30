import 'package:flutter/material.dart';
import 'package:sport_manager_mobile/l10n/l10n.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

class ManagersEmpty extends StatelessWidget {
  const ManagersEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x4,
        vertical: AppSpacing.x6,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.group_outlined,
            size: AppSpacing.x12,
            color: context.colors.onSurfaceVariant,
          ),
          const SizedBox(height: AppSpacing.x3),
          Text(
            context.l10n.managersEmptyTitle,
            style: context.textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.x2),
          Text(
            context.l10n.managersEmptySubtitle,
            style: context.appTextStyles.muted.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
