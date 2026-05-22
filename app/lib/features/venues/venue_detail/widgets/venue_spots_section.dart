import 'package:flutter/material.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

class VenueSpotsSection extends StatelessWidget {
  const VenueSpotsSection({
    required this.headerLabel,
    required this.countSuffix,
    required this.child,
    super.key,
  });

  final String headerLabel;
  final String? countSuffix;
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
                    headerLabel,
                    style: context.textTheme.bodySmall?.copyWith(
                      color: context.colors.onSurfaceVariant,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const Spacer(),
                  if (countSuffix != null)
                    Text(
                      countSuffix!,
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
