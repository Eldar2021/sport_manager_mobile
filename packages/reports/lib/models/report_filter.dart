import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:reports/models/report_period.dart';
import 'package:reports/models/report_range.dart';

@immutable
final class ReportFilter extends Equatable {
  const ReportFilter({
    required this.period,
    required this.range,
    this.venueId,
    this.compareToPrevious = true,
  });

  factory ReportFilter.initial(DateTime now) {
    return ReportFilter(
      period: ReportPeriod.month,
      range: ReportRange.fromPeriod(ReportPeriod.month, now),
    );
  }

  final ReportPeriod period;
  final ReportRange range;

  /// `null` → all venues for the owner.
  final String? venueId;

  /// When true the API returns the previous-period summary alongside the
  /// current one so KPI cards can render delta arrows.
  final bool compareToPrevious;

  /// Whether this period supports comparison/forecast UX. `false` for
  /// `today` — half-day data vs full previous day always paints a false
  /// "down 50%" picture, so KPI delta arrows and the Forecast card are
  /// hidden in Today view. Caller still gets absolute numbers.
  bool get supportsComparison => period != ReportPeriod.today;

  /// **Full** previous calendar period of the same kind — used by
  /// Forecast card ("Mayıs projeksiyonu vs tam Nisan"). Anchored on
  /// `range.from` so it's deterministic regardless of when the getter
  /// is called. `null` for `custom` — caller falls back to
  /// `range.previous` (same-length window before).
  ReportRange? get previousCalendarRange {
    final from = range.from;
    return switch (period) {
      ReportPeriod.today => ReportRange(
        from: from.subtract(const Duration(days: 1)),
        to: from,
      ),
      ReportPeriod.week => ReportRange(
        from: from.subtract(const Duration(days: 7)),
        to: from,
      ),
      ReportPeriod.month => ReportRange(
        from: DateTime(from.year, from.month - 1),
        to: DateTime(from.year, from.month),
      ),
      ReportPeriod.year => ReportRange(
        from: DateTime(from.year - 1),
        to: DateTime(from.year),
      ),
      ReportPeriod.custom => null,
    };
  }

  /// **Clipped** previous — geçen takvim periyodunun ilk N gününü
  /// döner (N = `range.length`). KPI delta'sı bu dilimi kullanır ki
  /// periyot kapanmadan "geçen periyodun tamamı"yla karşılaştırılıp
  /// yanıltıcı düşüş sinyali vermesin.
  ///
  /// Periyot tamamen kapalıysa (range.length == prev calendar length)
  /// clipped == previousCalendar olur — clipping no-op.
  ReportRange get clippedPreviousRange {
    final prevFull = previousCalendarRange ?? range.previous;
    final elapsed = range.length;
    final clippedTo = prevFull.from.add(elapsed);
    return ReportRange(
      from: prevFull.from,
      to: clippedTo.isBefore(prevFull.to) ? clippedTo : prevFull.to,
    );
  }

  ReportFilter copyWith({
    ReportPeriod? period,
    ReportRange? range,
    String? venueId,
    bool? compareToPrevious,
    bool clearVenue = false,
  }) {
    return ReportFilter(
      period: period ?? this.period,
      range: range ?? this.range,
      venueId: clearVenue ? null : (venueId ?? this.venueId),
      compareToPrevious: compareToPrevious ?? this.compareToPrevious,
    );
  }

  @override
  List<Object?> get props => [
    period,
    range,
    venueId,
    compareToPrevious,
  ];
}
