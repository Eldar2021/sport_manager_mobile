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
