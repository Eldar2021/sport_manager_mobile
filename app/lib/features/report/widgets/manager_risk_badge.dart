import 'package:flutter/material.dart';
import 'package:reports/reports.dart';
import 'package:sport_manager_mobile/l10n/l10n.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

/// Compact pill that shows a manager's risk band as a coloured chip with
/// a localized label. Uses the existing `AppColorsExt` tokens so it
/// adapts to light/dark.
class ManagerRiskBadge extends StatelessWidget {
  const ManagerRiskBadge({required this.band, super.key});

  final ManagerRiskBand band;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final (bg, fg, label) = switch (band) {
      ManagerRiskBand.green => (
        context.appColors.successContainer,
        context.appColors.onSuccessContainer,
        l10n.reportsManagerRiskLow,
      ),
      ManagerRiskBand.yellow => (
        context.appColors.warningContainer,
        context.appColors.onWarning,
        l10n.reportsManagerRiskMedium,
      ),
      ManagerRiskBand.red => (
        context.colors.errorContainer,
        context.colors.onErrorContainer,
        l10n.reportsManagerRiskHigh,
      ),
    };
    return DecoratedBox(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: AppRadius.chipBorderRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x2, vertical: 2),
        child: Text(label, style: context.textTheme.labelSmall?.copyWith(color: fg)),
      ),
    );
  }
}
