import 'package:flutter/material.dart';
import 'package:reports/reports.dart';
import 'package:sport_manager_mobile/l10n/l10n.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

class FraudFlagList extends StatelessWidget {
  const FraudFlagList(this.flags, {super.key});

  final List<FraudFlagModel> flags;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    if (flags.isEmpty) {
      return Card(
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.x4),
          child: Row(
            children: [
              Icon(
                Icons.verified_outlined,
                color: context.appColors.success,
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Text(
                  l10n.reportsFraudNoFlags,
                  style: context.textTheme.bodyMedium,
                ),
              ),
            ],
          ),
        ),
      );
    }
    return Card(
      margin: EdgeInsets.zero,
      child: Column(
        children: [
          for (var i = 0; i < flags.length; i++) ...[
            if (i != 0) const Divider(height: 1),
            _FlagRow(flags[i]),
          ],
        ],
      ),
    );
  }
}

class _FlagRow extends StatelessWidget {
  const _FlagRow(this.flag);

  final FraudFlagModel flag;

  Color _severityColor(BuildContext context) {
    return switch (flag.severity) {
      InsightSeverity.critical => context.colors.error,
      InsightSeverity.warning => context.appColors.warning,
      InsightSeverity.info => context.appColors.info,
    };
  }

  String _label(AppLocalizations l10n) {
    return switch (flag.code) {
      FraudFlagCode.highCancelRate => l10n.reportsFraudHighCancelRate,
      FraudFlagCode.highCancel60s => l10n.reportsFraudHighCancel60s,
      FraudFlagCode.highDiscountRate => l10n.reportsFraudHighDiscountRate,
      FraudFlagCode.highAvgDiscount => l10n.reportsFraudHighAvgDiscount,
      FraudFlagCode.longPauseAvg => l10n.reportsFraudLongPauseAvg,
      FraudFlagCode.manyPausePerSession => l10n.reportsFraudManyPausePerSession,
      FraudFlagCode.offHoursActivity => l10n.reportsFraudOffHoursActivity,
      FraudFlagCode.shortSessionCluster => l10n.reportsFraudShortSessionCluster,
      FraudFlagCode.tariffOverride => l10n.reportsFraudTariffOverride,
      FraudFlagCode.lowShiftRevenue => l10n.reportsFraudLowShiftRevenue,
      FraudFlagCode.unknown => '—',
    };
  }

  String _multiplierLabel(AppLocalizations l10n) {
    final m = flag.multiplier;
    if (m == null) return '';
    return l10n.reportsFraudMultiplier(m.toStringAsFixed(1));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.x3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Icon(
              Icons.flag_outlined,
              color: _severityColor(context),
              size: 20,
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _label(l10n),
                  style: context.textTheme.bodyMedium,
                ),
                if (flag.benchmark > 0)
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(
                      _multiplierLabel(l10n),
                      style: context.appTextStyles.muted.labelSmall,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
