import 'package:flutter/material.dart';
import 'package:sport_manager_mobile/l10n/l10n.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

class TablesSection extends StatelessWidget {
  const TablesSection({
    required this.count,
    required this.child,
    super.key,
  });

  final int? count;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.x2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.x4,
                AppSpacing.x2,
                AppSpacing.x4,
                AppSpacing.x2,
              ),
              child: Row(
                children: [
                  Text(
                    context.l10n.venueDetailTablesHeader,
                    style: context.textTheme.bodySmall?.copyWith(
                      color: context.colors.onSurfaceVariant,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const Spacer(),
                  if (count != null)
                    Text(
                      context.l10n.venueTablesCountSuffix(count!),
                      style: context.appTextStyles.muted.bodySmall,
                    ),
                ],
              ),
            ),
            const Divider(height: 1),
            child,
          ],
        ),
      ),
    );
  }
}
