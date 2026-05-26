import 'package:flutter/material.dart';
import 'package:manager_reports/manager_reports.dart';
import 'package:sport_manager_mobile/l10n/l10n.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

/// Four amber pill chips (Сегодня / Неделя / Месяц / Год) shown directly
/// under the AppBar. Replaces the Material TabBar visually but keeps tab
/// semantics — the parent owns the `selected` index.
class ManagerReportChipBar extends StatelessWidget {
  const ManagerReportChipBar({
    required this.selected,
    required this.onSelected,
    super.key,
  });

  final ManagerReportPeriod selected;
  final ValueChanged<ManagerReportPeriod> onSelected;

  static const List<ManagerReportPeriod> _periods = ManagerReportPeriod.values;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x4),
      child: Row(
        children: [
          for (final p in _periods) ...[
            _PeriodChip(
              label: _label(p, l10n),
              selected: p == selected,
              onPressed: () => onSelected(p),
            ),
            const SizedBox(width: AppSpacing.x2),
          ],
        ],
      ),
    );
  }

  String _label(ManagerReportPeriod p, AppLocalizations l10n) {
    return switch (p) {
      ManagerReportPeriod.today => l10n.managerReportsPeriodToday,
      ManagerReportPeriod.week => l10n.managerReportsPeriodWeek,
      ManagerReportPeriod.month => l10n.managerReportsPeriodMonth,
      ManagerReportPeriod.year => l10n.managerReportsPeriodYear,
    };
  }
}

class _PeriodChip extends StatelessWidget {
  const _PeriodChip({
    required this.label,
    required this.selected,
    required this.onPressed,
  });

  final String label;
  final bool selected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final bg = selected ? context.colors.primary : context.colors.surfaceContainerHighest;
    final fg = selected ? context.colors.onPrimary : context.colors.onSurface;
    return Material(
      color: bg,
      borderRadius: AppRadius.chipBorderRadius,
      child: InkWell(
        borderRadius: AppRadius.chipBorderRadius,
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.x4,
            vertical: AppSpacing.x2,
          ),
          child: Text(
            label,
            style: context.textTheme.labelLarge?.copyWith(
              color: fg,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
