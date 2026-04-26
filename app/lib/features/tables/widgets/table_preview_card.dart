import 'package:flutter/material.dart';
import 'package:sport_manager_mobile/l10n/l10n.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

class TablePreviewCard extends StatelessWidget {
  const TablePreviewCard({
    required this.name,
    required this.description,
    required this.hourlyRate,
    super.key,
  });

  final String name;
  final String description;
  final int hourlyRate;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final hasName = name.trim().isNotEmpty;
    final hasDesc = description.trim().isNotEmpty;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: AppRadius.cardBorderRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.x4),
        child: Row(
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                color: AppColors.brandAmberLight,
                borderRadius: BorderRadius.circular(AppSpacing.x3),
              ),
              child: const Padding(
                padding: EdgeInsets.all(AppSpacing.x3),
                child: Icon(Icons.adjust_rounded, color: AppColors.brandAmber, size: 28),
              ),
            ),
            const SizedBox(width: AppSpacing.x3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    hasName ? name : l10n.createTableNameLabel,
                    style: context.textTheme.bodyLarge?.copyWith(
                      color: hasName ? AppColors.ink900 : AppColors.ink300,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (hasDesc || !hasName) ...[
                    const SizedBox(height: 2),
                    Text(
                      hasDesc ? description : l10n.createTableDescPlaceholder,
                      style: context.textTheme.bodySmall?.copyWith(color: AppColors.ink300),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.x3),
            DecoratedBox(
              decoration: const BoxDecoration(
                color: AppColors.brandAmberLight,
                borderRadius: AppRadius.chipBorderRadius,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.x3,
                  vertical: AppSpacing.x1,
                ),
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: '$hourlyRate',
                        style: context.textTheme.bodyLarge?.copyWith(color: AppColors.brandAmber),
                      ),
                      TextSpan(
                        text: ' ${l10n.createTableRateSuffix}',
                        style: context.textTheme.bodySmall?.copyWith(color: AppColors.brandAmber),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
