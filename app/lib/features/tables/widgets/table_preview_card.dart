import 'package:facility/facility.dart';
import 'package:flutter/material.dart';
import 'package:sport_manager_mobile/l10n/l10n.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

class TablePreviewCard extends StatelessWidget {
  const TablePreviewCard({
    required this.name,
    required this.description,
    required this.tarifAmount,
    required this.tarifType,
    required this.currency,
    super.key,
  });

  final String name;
  final String description;
  final int tarifAmount;
  final TarifType tarifType;
  final Currency currency;

  @override
  Widget build(BuildContext context) {
    final hasName = name.trim().isNotEmpty;
    final hasDesc = description.trim().isNotEmpty;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: AppRadius.cardBorderRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.x4),
        child: Row(
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                color: context.colors.primaryContainer,
                borderRadius: BorderRadius.circular(AppSpacing.x3),
              ),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.x3),
                child: Icon(Icons.adjust_rounded, color: context.colors.primary, size: 28),
              ),
            ),
            const SizedBox(width: AppSpacing.x3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    hasName ? name : context.l10n.createTableNameLabel,
                    style: context.textTheme.bodyLarge?.copyWith(
                      color: hasName ? context.colors.onSurface : context.colors.outline,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (hasDesc || !hasName) ...[
                    const SizedBox(height: 2),
                    Text(
                      hasDesc ? description : context.l10n.createTableDescPlaceholder,
                      style: context.textTheme.bodySmall?.copyWith(color: context.colors.outline),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.x3),
            DecoratedBox(
              decoration: BoxDecoration(
                color: context.colors.primaryContainer,
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
                        text: '$tarifAmount',
                        style: context.textTheme.bodyLarge?.copyWith(color: context.colors.primary),
                      ),
                      TextSpan(
                        text: ' ${context.l10n.createTableRateSuffix(currency.label, tarifType.label)}',
                        style: context.textTheme.bodySmall?.copyWith(color: context.colors.primary),
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
