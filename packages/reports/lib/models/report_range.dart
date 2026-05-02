import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:reports/models/report_period.dart';

@immutable
final class ReportRange extends Equatable {
  const ReportRange({required this.from, required this.to});

  /// Builds a range for [period] anchored on [now]. For [ReportPeriod.custom]
  /// callers must supply the dates explicitly via [ReportRange.new].
  factory ReportRange.fromPeriod(ReportPeriod period, DateTime now) {
    final today = DateTime(now.year, now.month, now.day);
    return switch (period) {
      ReportPeriod.today => ReportRange(
        from: today,
        to: today.add(const Duration(days: 1)),
      ),
      ReportPeriod.week => ReportRange(
        from: today.subtract(Duration(days: today.weekday - 1)),
        to: today.add(const Duration(days: 1)),
      ),
      ReportPeriod.month => ReportRange(
        from: DateTime(today.year, today.month),
        to: today.add(const Duration(days: 1)),
      ),
      ReportPeriod.year => ReportRange(
        from: DateTime(today.year),
        to: today.add(const Duration(days: 1)),
      ),
      ReportPeriod.custom => ReportRange(
        from: today,
        to: today.add(const Duration(days: 1)),
      ),
    };
  }

  final DateTime from;
  final DateTime to;

  Duration get length => to.difference(from);

  /// Same length, immediately before this range.
  ReportRange get previous {
    return ReportRange(
      from: from.subtract(length),
      to: from,
    );
  }

  @override
  List<Object?> get props => [
    from,
    to,
  ];
}
