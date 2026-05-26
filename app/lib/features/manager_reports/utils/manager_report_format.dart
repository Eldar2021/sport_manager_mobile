import 'package:facility/facility.dart';
import 'package:manager_reports/manager_reports.dart';
import 'package:sport_manager_mobile/l10n/l10n.dart';

/// Display formatters for manager-reports screens. All locale-sensitive
/// strings go through `AppLocalizations`; numeric formatting (thousand
/// separators, fixed-width times) is done locally to avoid an `intl`
/// locale-data round-trip in widget builds.
abstract final class ManagerReportFormat {
  /// `28218` → `28 218`. Space is the thousand separator across all locales.
  static String amount(int value) {
    if (value == 0) return '0';
    final negative = value < 0;
    final s = (negative ? -value : value).toString();
    final buf = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write(' ');
      buf.write(s[i]);
    }
    return negative ? '-$buf' : '$buf';
  }

  static String currencySuffix(Currency currency, AppLocalizations l10n) {
    return switch (currency) {
      Currency.kgs => l10n.managerReportsCurrencyKgs,
      Currency.usd => l10n.managerReportsCurrencyUsd,
      Currency.rub => l10n.managerReportsCurrencyRub,
      Currency.kzt => l10n.managerReportsCurrencyKzt,
      Currency.tryLira => l10n.managerReportsCurrencyTry,
    };
  }

  /// `9120` → `2ч 32м` (locale-aware via `managerReportsDurationHm`).
  /// Pure minutes (< 1h) → `38 мин`; whole hours → `5ч`.
  static String duration(int seconds, AppLocalizations l10n) {
    final h = seconds ~/ 3600;
    final m = (seconds % 3600) ~/ 60;
    if (h == 0) return l10n.managerReportsDurationM(m);
    if (m == 0) return l10n.managerReportsDurationH(h);
    return l10n.managerReportsDurationHm(h, m);
  }

  /// `DateTime(…, 11, 2)` → `11:02`. Local time only — sessions are already
  /// `startedAt.toLocal()` when the cubit receives them.
  static String timeOfDay(DateTime t) {
    final local = t.toLocal();
    return '${_two(local.hour)}:${_two(local.minute)}';
  }

  static String dayOfWeekFull(DayOfWeek d, AppLocalizations l10n) {
    return switch (d) {
      DayOfWeek.monday => l10n.managerReportsDayOfWeekMon,
      DayOfWeek.tuesday => l10n.managerReportsDayOfWeekTue,
      DayOfWeek.wednesday => l10n.managerReportsDayOfWeekWed,
      DayOfWeek.thursday => l10n.managerReportsDayOfWeekThu,
      DayOfWeek.friday => l10n.managerReportsDayOfWeekFri,
      DayOfWeek.saturday => l10n.managerReportsDayOfWeekSat,
      DayOfWeek.sunday => l10n.managerReportsDayOfWeekSun,
    };
  }

  static String dayOfWeekShort(DayOfWeekShort d, AppLocalizations l10n) {
    return switch (d) {
      DayOfWeekShort.mon => l10n.managerReportsDayOfWeekShortMon,
      DayOfWeekShort.tue => l10n.managerReportsDayOfWeekShortTue,
      DayOfWeekShort.wed => l10n.managerReportsDayOfWeekShortWed,
      DayOfWeekShort.thu => l10n.managerReportsDayOfWeekShortThu,
      DayOfWeekShort.fri => l10n.managerReportsDayOfWeekShortFri,
      DayOfWeekShort.sat => l10n.managerReportsDayOfWeekShortSat,
      DayOfWeekShort.sun => l10n.managerReportsDayOfWeekShortSun,
    };
  }

  static String monthShort(MonthShort m, AppLocalizations l10n) {
    return switch (m) {
      MonthShort.jan => l10n.managerReportsMonthShortJan,
      MonthShort.feb => l10n.managerReportsMonthShortFeb,
      MonthShort.mar => l10n.managerReportsMonthShortMar,
      MonthShort.apr => l10n.managerReportsMonthShortApr,
      MonthShort.may => l10n.managerReportsMonthShortMay,
      MonthShort.jun => l10n.managerReportsMonthShortJun,
      MonthShort.jul => l10n.managerReportsMonthShortJul,
      MonthShort.aug => l10n.managerReportsMonthShortAug,
      MonthShort.sep => l10n.managerReportsMonthShortSep,
      MonthShort.oct => l10n.managerReportsMonthShortOct,
      MonthShort.nov => l10n.managerReportsMonthShortNov,
      MonthShort.dec => l10n.managerReportsMonthShortDec,
    };
  }

  static String monthLong(int month, AppLocalizations l10n) {
    return switch (month) {
      1 => l10n.managerReportsMonthLongJan,
      2 => l10n.managerReportsMonthLongFeb,
      3 => l10n.managerReportsMonthLongMar,
      4 => l10n.managerReportsMonthLongApr,
      5 => l10n.managerReportsMonthLongMay,
      6 => l10n.managerReportsMonthLongJun,
      7 => l10n.managerReportsMonthLongJul,
      8 => l10n.managerReportsMonthLongAug,
      9 => l10n.managerReportsMonthLongSep,
      10 => l10n.managerReportsMonthLongOct,
      11 => l10n.managerReportsMonthLongNov,
      _ => l10n.managerReportsMonthLongDec,
    };
  }

  /// `24 Май 2026`.
  static String fullDate(DateTime date, AppLocalizations l10n) {
    final month = monthLong(date.month, l10n);
    return '${date.day} $month ${date.year}';
  }

  /// `18 май` — used inside the week-range subtitle.
  static String dayMonthShort(DateTime date, AppLocalizations l10n) {
    final month = monthLong(date.month, l10n).toLowerCase();
    return '${date.day} $month';
  }

  /// `Май 2026`.
  static String monthYear(int year, int month, AppLocalizations l10n) {
    return '${monthLong(month, l10n)} $year';
  }

  /// `Янв 2026`.
  static String monthShortYear(MonthShort m, int year, AppLocalizations l10n) {
    return '${monthShort(m, l10n)} $year';
  }

  static String _two(int v) => v < 10 ? '0$v' : '$v';
}
