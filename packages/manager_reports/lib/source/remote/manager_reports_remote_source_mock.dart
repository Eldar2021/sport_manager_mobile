import 'dart:math';

import 'package:facility/facility.dart';
import 'package:manager_reports/manager_reports.dart';

/// Deterministic-ish mock for dev mode. Generates one busy session per
/// day around mid-day, with a couple of zero-session rest days mixed in
/// so the UI exercises both shapes. Currency is fixed to KGS.
final class ManagerReportsRemoteSourceMock implements ManagerReportsRemoteSource {
  ManagerReportsRemoteSourceMock();

  static const _delay = Duration(milliseconds: 400);
  static const Currency _currency = Currency.kgs;

  final Random _rng = Random(42);

  @override
  Future<DayReportModel> getToday({String? timezone}) async {
    await Future<void>.delayed(_delay);
    final today = _todayLocal();
    return _buildDayReport(today, includeSessions: true);
  }

  @override
  Future<WeekReportModel> getWeek({String? timezone}) async {
    await Future<void>.delayed(_delay);
    final today = _todayLocal();
    final monday = today.subtract(Duration(days: today.weekday - DateTime.monday));
    final sunday = monday.add(const Duration(days: 6));

    final days = List.generate(7, (i) {
      final d = monday.add(Duration(days: i));
      return _buildDayCard(d, today: today);
    });

    return WeekReportModel(
      weekStart: monday,
      weekEnd: sunday,
      summary: _sumDays(days),
      days: days,
    );
  }

  @override
  Future<MonthReportModel> getMonth({String? timezone}) async {
    await Future<void>.delayed(_delay);
    final today = _todayLocal();
    return _buildMonthReport(today.year, today.month, today: today);
  }

  @override
  Future<YearReportModel> getYear({String? timezone}) async {
    await Future<void>.delayed(_delay);
    final today = _todayLocal();
    final months = List.generate(12, (i) => i + 1);

    final cards = months
        .map((m) {
          final isFuture = m > today.month;
          final isCurrent = m == today.month;
          final monthRevenue = isFuture ? 0 : 20000 + _rng.nextInt(15000);
          final monthSessions = isFuture ? 0 : 40 + _rng.nextInt(40);
          final monthShift = isFuture ? 0 : monthSessions * 4800;
          return MonthCardModel(
            year: today.year,
            month: m,
            monthShort: _monthShortOf(m),
            revenue: monthRevenue,
            currency: _currency,
            sessions: monthSessions,
            shiftSeconds: monthShift,
            isCurrent: isCurrent,
            isFuture: isFuture,
            progressRatio: 0,
          );
        })
        .toList(growable: false);

    final maxRevenue = cards.fold<int>(0, (max, c) => c.revenue > max ? c.revenue : max);
    final normalized = cards
        .map(
          (c) => MonthCardModel(
            year: c.year,
            month: c.month,
            monthShort: c.monthShort,
            revenue: c.revenue,
            currency: c.currency,
            sessions: c.sessions,
            shiftSeconds: c.shiftSeconds,
            isCurrent: c.isCurrent,
            isFuture: c.isFuture,
            progressRatio: maxRevenue == 0 ? 0 : c.revenue / maxRevenue,
          ),
        )
        .toList(growable: false);

    final yearRevenue = normalized.fold<int>(0, (sum, c) => sum + c.revenue);
    final yearSessions = normalized.fold<int>(0, (sum, c) => sum + c.sessions);
    final yearShift = normalized.fold<int>(0, (sum, c) => sum + c.shiftSeconds);

    return YearReportModel(
      year: today.year,
      summary: ReportSummaryModel(
        revenue: yearRevenue,
        currency: _currency,
        sessions: yearSessions,
        shiftSeconds: yearShift,
      ),
      months: normalized,
    );
  }

  @override
  Future<DayReportModel> getDayDetail(DateTime date, {String? timezone}) async {
    await Future<void>.delayed(_delay);
    return _buildDayReport(date, includeSessions: true);
  }

  @override
  Future<MonthReportModel> getMonthDetail({
    required int year,
    required int month,
    String? timezone,
  }) async {
    await Future<void>.delayed(_delay);
    return _buildMonthReport(year, month, today: _todayLocal());
  }

  DateTime _todayLocal() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  bool _isRestDay(DateTime d) => d.day % 6 == 0;

  DayReportModel _buildDayReport(DateTime date, {required bool includeSessions}) {
    final today = _todayLocal();
    final isFuture = date.isAfter(today);
    final restDay = isFuture || _isRestDay(date);

    if (restDay) {
      return DayReportModel(
        date: date,
        dayOfWeek: _dayOfWeekOf(date),
        summary: const ReportSummaryModel(
          revenue: 0,
          currency: _currency,
          sessions: 0,
          shiftSeconds: 0,
        ),
        sessions: const [],
      );
    }

    final sessions = _generateSessions(date, count: 2 + _rng.nextInt(2));
    final revenue = sessions.fold<int>(0, (sum, s) => sum + s.totalAmount);
    final shiftSeconds = sessions.fold<int>(0, (sum, s) => sum + s.durationSeconds);

    return DayReportModel(
      date: date,
      dayOfWeek: _dayOfWeekOf(date),
      summary: ReportSummaryModel(
        revenue: revenue,
        currency: _currency,
        sessions: sessions.length,
        shiftSeconds: shiftSeconds,
      ),
      sessions: includeSessions ? sessions : const [],
    );
  }

  DayCardModel _buildDayCard(DateTime date, {required DateTime today}) {
    final isFuture = date.isAfter(today);
    final isDayOff = isFuture || _isRestDay(date);
    final sessions = isDayOff ? 0 : 2 + _rng.nextInt(2);
    final revenue = isDayOff ? 0 : 500 + _rng.nextInt(1000);
    final shiftSeconds = isDayOff ? 0 : sessions * 4500;

    return DayCardModel(
      date: date,
      dayOfWeek: _dayOfWeekOf(date),
      dayOfMonth: date.day,
      shortDayOfWeek: _shortDayOfWeekOf(date),
      revenue: revenue,
      currency: _currency,
      sessions: sessions,
      shiftSeconds: shiftSeconds,
      isToday: _isSameDay(date, today),
      isFuture: isFuture,
      isDayOff: isDayOff,
    );
  }

  MonthReportModel _buildMonthReport(int year, int month, {required DateTime today}) {
    final daysInMonth = DateUtils.daysInMonth(year, month);
    final days = List.generate(daysInMonth, (i) {
      final d = DateTime(year, month, i + 1);
      return _buildDayCard(d, today: today);
    });

    return MonthReportModel(
      year: year,
      month: month,
      monthShort: _monthShortOf(month),
      summary: _sumDays(days),
      days: days,
    );
  }

  List<SessionCardModel> _generateSessions(DateTime date, {required int count}) {
    return List.generate(count, (i) {
      final start = DateTime(date.year, date.month, date.day, 12 + i * 2);
      final durationSeconds = 1800 + _rng.nextInt(3600);
      final end = start.add(Duration(seconds: durationSeconds));
      final subtotal = 300 + _rng.nextInt(400);
      final productsAmount = _rng.nextBool() ? _rng.nextInt(200) : 0;
      return SessionCardModel(
        id: 'mock-session-${date.millisecondsSinceEpoch}-$i',
        spotId: 'mock-spot-${i + 1}',
        spotName: 'Стол ${i + 3}',
        spotNumber: i + 3,
        venueId: 'mock-venue-1',
        venueName: 'Основной',
        venueType: VenueType.billiards,
        customerName: _rng.nextBool() ? null : 'Asan',
        startedAt: start,
        endedAt: end,
        durationSeconds: durationSeconds,
        currency: _currency,
        subtotal: subtotal,
        productsAmount: productsAmount,
        totalAmount: subtotal + productsAmount,
      );
    });
  }

  ReportSummaryModel _sumDays(List<DayCardModel> days) {
    final revenue = days.fold<int>(0, (sum, d) => sum + d.revenue);
    final sessions = days.fold<int>(0, (sum, d) => sum + d.sessions);
    final shiftSeconds = days.fold<int>(0, (sum, d) => sum + d.shiftSeconds);
    return ReportSummaryModel(
      revenue: revenue,
      currency: _currency,
      sessions: sessions,
      shiftSeconds: shiftSeconds,
    );
  }

  bool _isSameDay(DateTime a, DateTime b) => a.year == b.year && a.month == b.month && a.day == b.day;

  static DayOfWeek _dayOfWeekOf(DateTime d) => switch (d.weekday) {
    DateTime.monday => DayOfWeek.monday,
    DateTime.tuesday => DayOfWeek.tuesday,
    DateTime.wednesday => DayOfWeek.wednesday,
    DateTime.thursday => DayOfWeek.thursday,
    DateTime.friday => DayOfWeek.friday,
    DateTime.saturday => DayOfWeek.saturday,
    _ => DayOfWeek.sunday,
  };

  static DayOfWeekShort _shortDayOfWeekOf(DateTime d) => switch (d.weekday) {
    DateTime.monday => DayOfWeekShort.mon,
    DateTime.tuesday => DayOfWeekShort.tue,
    DateTime.wednesday => DayOfWeekShort.wed,
    DateTime.thursday => DayOfWeekShort.thu,
    DateTime.friday => DayOfWeekShort.fri,
    DateTime.saturday => DayOfWeekShort.sat,
    _ => DayOfWeekShort.sun,
  };

  static MonthShort _monthShortOf(int month) => switch (month) {
    1 => MonthShort.jan,
    2 => MonthShort.feb,
    3 => MonthShort.mar,
    4 => MonthShort.apr,
    5 => MonthShort.may,
    6 => MonthShort.jun,
    7 => MonthShort.jul,
    8 => MonthShort.aug,
    9 => MonthShort.sep,
    10 => MonthShort.oct,
    11 => MonthShort.nov,
    _ => MonthShort.dec,
  };
}

/// Local copy of Flutter's `DateUtils.getDaysInMonth` so this package
/// doesn't pull in the framework dependency just for that helper.
abstract final class DateUtils {
  static int daysInMonth(int year, int month) {
    const days = [31, -1, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
    if (month == DateTime.february) {
      final leap = (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0);
      return leap ? 29 : 28;
    }
    return days[month - 1];
  }
}
