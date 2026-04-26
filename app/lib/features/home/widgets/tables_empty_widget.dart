import 'package:flutter/material.dart';
import 'package:sport_manager_mobile/l10n/l10n.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

class TablesEmptyWidget extends StatelessWidget {
  const TablesEmptyWidget({this.onAddTap, super.key});

  final VoidCallback? onAddTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: AppColors.ink100,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(Icons.table_restaurant_outlined, color: AppColors.ink500, size: 36),
            ),
            const SizedBox(height: AppSpacing.x4),
            Text(
              l10n.homeTablesEmpty,
              style: AppTypography.h2,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.x2),
            Text(
              l10n.homeTablesEmptySub,
              style: AppTypography.body.copyWith(color: AppColors.ink500),
              textAlign: TextAlign.center,
            ),
            if (onAddTap != null) ...[
              const SizedBox(height: AppSpacing.x6),
              FilledButton.icon(
                onPressed: onAddTap,
                icon: const Icon(Icons.add_rounded, size: 18),
                label: Text(l10n.homeAddTable),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
