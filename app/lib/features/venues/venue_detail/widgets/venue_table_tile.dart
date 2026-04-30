import 'package:facility/facility.dart';
import 'package:flutter/material.dart';
import 'package:sport_manager_mobile/core/core.dart';
import 'package:sport_manager_mobile/l10n/l10n.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

class VenueTableTile extends StatelessWidget {
  const VenueTableTile({
    required this.table,
    required this.onTap,
    super.key,
  });

  final TableModel table;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final description = table.description;
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.x4),
      leading: DecoratedBox(
        decoration: BoxDecoration(
          color: context.colors.surfaceContainer,
          shape: BoxShape.circle,
        ),
        child: SizedBox(
          width: AppSpacing.x10,
          height: AppSpacing.x10,
          child: Center(
            child: Icon(
              Icons.play_arrow_rounded,
              color: context.colors.onSurfaceVariant,
              size: AppSpacing.x5,
            ),
          ),
        ),
      ),
      title: Text(
        table.name ?? l10n.homeTableTitle(table.number),
        style: context.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w700),
      ),
      subtitle: description != null && description.isNotEmpty
          ? Text(
              '«$description»',
              style: context.appTextStyles.muted.bodySmall,
            )
          : null,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
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
              child: Text(
                '${table.tarifAmount} ${table.currency.localizedName(l10n)}',
                style: context.textTheme.bodySmall?.copyWith(
                  color: context.colors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.x2),
          Icon(
            Icons.arrow_forward_ios,
            size: AppSpacing.x4,
            color: context.colors.onSurfaceVariant,
          ),
        ],
      ),
    );
  }
}
