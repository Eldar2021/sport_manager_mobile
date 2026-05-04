import 'package:flutter/material.dart';
import 'package:reports/reports.dart';
import 'package:sport_manager_mobile/features/report/report.dart';
import 'package:sport_manager_mobile/l10n/l10n.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

/// Tek satır küçük caption: "4–7 May  ·  vs 27–30 Nis".
///
/// `filter.supportsComparison` false ise (Today periyodu) sadece current
/// range yazılır, "vs" kısmı gizlenir. Bu sayede owner KPI delta'sının
/// hangi tarih aralığı ile hesaplandığını net görür — orijinal
/// problemin çözümü: "1-30 sanılırdı" hatasını yapmasın.
class ReportComparisonLabel extends StatelessWidget {
  const ReportComparisonLabel(this.filter, {super.key});

  final ReportFilter filter;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    final current = ReportFormat.rangeLabel(filter.range, filter.period, locale);
    final style = context.appTextStyles.muted.labelSmall;

    if (!filter.supportsComparison) {
      return Text(current, style: style);
    }

    final previous = ReportFormat.rangeLabel(filter.clippedPreviousRange, filter.period, locale);
    return Text(
      context.l10n.reportsComparisonCaption(current, previous),
      style: style,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}
