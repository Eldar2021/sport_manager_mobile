import 'package:facility/facility.dart';
import 'package:intl/intl.dart';
import 'package:reports/reports.dart';

/// Money / duration / delta helpers used across the report feature. Kept
/// as plain top-level functions so callers don't need to instantiate.
abstract final class ReportFormat {
  static final _intGrouped = NumberFormat.decimalPattern();

  /// Formats an integer money amount with grouping + currency suffix
  /// (`142 500 сом`). Locale grouping comes from Intl; currency code is
  /// the localized short name ("сом" / "$" / "₽" / etc).
  static String money(int amount, Currency currency) {
    return '${_intGrouped.format(amount)} ${_currencyShort(currency)}';
  }

  /// Compact money suffix without separator — used inside dense charts
  /// where the full string is too wide.
  static String moneyCompact(int amount, Currency currency) {
    if (amount.abs() >= 1000000) {
      return '${(amount / 1000000).toStringAsFixed(1)}M';
    }
    if (amount.abs() >= 1000) {
      return '${(amount / 1000).toStringAsFixed(amount % 1000 == 0 ? 0 : 1)}k';
    }
    return amount.toString();
  }

  static const _hr = 'ч';
  static const _min = 'м';
  static const _sec = 'с';

  /// Renders a duration as "1ч 23м" / "47м" / "32с".
  static String duration(int seconds) {
    if (seconds < 60) return '$seconds$_sec';
    final minutes = seconds ~/ 60;
    if (minutes < 60) return '$minutes$_min';
    final hours = minutes ~/ 60;
    final restMin = minutes % 60;
    if (restMin == 0) return '$hours$_hr';
    return '$hours$_hr $restMin$_min';
  }

  /// Returns "+12%" / "-3%" or "—" for null. Caller decides the color.
  static String delta(int? deltaPercent) {
    if (deltaPercent == null) return '—';
    if (deltaPercent == 0) return '0%';
    final sign = deltaPercent > 0 ? '+' : '';
    return '$sign$deltaPercent%';
  }

  /// Single-letter weekday following ISO 8601 (1=Mon … 7=Sun) in the
  /// active locale.
  static String weekdayShort(int isoWeekday, String locale) {
    final base = DateTime(2024); // 2024-01-01 is a Monday
    final date = base.add(Duration(days: isoWeekday - 1));
    return DateFormat('E', locale).format(date);
  }

  /// Compact human-readable label for a [ReportRange]. Used in the
  /// "current vs previous" comparison caption above KPI grids and in the
  /// Forecast card. Examples (English locale):
  ///
  /// - `today` (single day)        → "May 5"
  /// - `week` / `month` (range)    → "May 4 – May 7"
  /// - `year` (months in a year)   → "Jan – May 2026"
  ///
  /// Locale-sensitive: order/separators come from the active `DateFormat`.
  static String rangeLabel(ReportRange range, ReportPeriod period, String locale) {
    final from = range.from;
    // range.to is exclusive — the last visible day is the one before.
    final lastDay = range.to.subtract(const Duration(days: 1));

    if (period == ReportPeriod.year) {
      final monthOnly = DateFormat.MMM(locale);
      final fromLabel = monthOnly.format(from);
      final toLabel = monthOnly.format(lastDay);
      if (fromLabel == toLabel) return '$fromLabel ${from.year}';
      return '$fromLabel – $toLabel ${from.year}';
    }

    final dayMonth = DateFormat.MMMd(locale);
    final isSingleDay = from.year == lastDay.year && from.month == lastDay.month && from.day == lastDay.day;
    if (isSingleDay) return dayMonth.format(from);

    return '${dayMonth.format(from)} – ${dayMonth.format(lastDay)}';
  }

  static String _currencyShort(Currency c) {
    return switch (c) {
      Currency.kgs => 'сом',
      Currency.usd => 'USD',
      Currency.rub => '₽',
      Currency.kzt => '₸',
      Currency.tryLira => '₺',
    };
  }
}
