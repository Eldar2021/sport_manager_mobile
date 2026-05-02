import 'dart:math';

import 'package:facility/facility.dart';
import 'package:reports/reports.dart';

/// Synthetic data store used while the backend is not yet wired. Generates
/// ~90 days of session-level data so every report endpoint has something
/// realistic to render. Deliberately MVP-scoped — no fraud-signal logic,
/// no per-manager risk scoring, just plain revenue and session counts.
final class ReportsRemoteSourceMock implements ReportsRemoteSource {
  ReportsRemoteSourceMock() : _store = _MockStore.seed();

  static const _delay = Duration(milliseconds: 400);

  final _MockStore _store;

  @override
  Future<List<ReportVenueModel>> getVenues() async {
    await Future<void>.delayed(_delay);
    return List.unmodifiable(_store.venues);
  }

  @override
  Future<ReportsSummaryModel> getSummary(ReportFilter filter) async {
    await Future<void>.delayed(_delay);

    final current = _store.summary(
      filter.range,
      venueId: filter.venueId,
    );

    if (!filter.compareToPrevious) return current;

    final previousRange = _store.clippedPreviousRange(filter);

    final previous = _store.summary(
      previousRange,
      venueId: filter.venueId,
    );

    return ReportsSummaryModel(
      totalRevenue: current.totalRevenue,
      totalSessions: current.totalSessions,
      cancelledSessions: current.cancelledSessions,
      avgDurationSeconds: current.avgDurationSeconds,
      occupancyPercent: current.occupancyPercent,
      activeNow: current.activeNow,
      activeMax: current.activeMax,
      currency: current.currency,
      previous: previous,
    );
  }

  @override
  Future<List<RevenuePointModel>> getRevenueSeries(ReportFilter filter) async {
    await Future<void>.delayed(_delay);
    return _store.revenueSeries(filter);
  }

  @override
  Future<List<TableReportRowModel>> getTables(ReportFilter filter) async {
    await Future<void>.delayed(_delay);
    return _store.tableRows(filter);
  }

  @override
  Future<List<ManagerReportRowModel>> getManagers(ReportFilter filter) async {
    await Future<void>.delayed(_delay);
    return _store.managerRows(filter);
  }

  @override
  Future<ForecastModel> getForecast(ReportFilter filter) async {
    await Future<void>.delayed(_delay);
    return _store.forecast(filter);
  }

  @override
  Future<ManagerReportDetailModel> getManagerDetail(
    String managerId,
    ReportFilter filter,
  ) async {
    await Future<void>.delayed(_delay);
    return _store.managerDetail(managerId, filter);
  }

  @override
  Future<TableReportDetailModel> getTableDetail(
    String tableId,
    ReportFilter filter,
  ) async {
    await Future<void>.delayed(_delay);
    return _store.tableDetail(tableId, filter);
  }
}

// ───────────────────────── synthetic data engine ─────────────────────────

enum _MockSessionStatus { completed, cancelled }

class _MockTable {
  _MockTable({
    required this.id,
    required this.venueId,
    required this.number,
    required this.tarifAmount,
    this.name,
  });

  final String id;
  final String venueId;
  final int number;
  final int tarifAmount;
  final String? name;
}

class _MockManager {
  _MockManager({
    required this.id,
    required this.name,
    required this.username,
  });

  final String id;
  final String name;
  final String username;
}

class _MockSession {
  _MockSession({
    required this.id,
    required this.tableId,
    required this.managerId,
    required this.startedAt,
    required this.endedAt,
    required this.durationSeconds,
    required this.status,
    required this.totalAmount,
  });

  final String id;
  final String tableId;
  final String managerId;
  final DateTime startedAt;
  final DateTime endedAt;
  final int durationSeconds;
  final _MockSessionStatus status;
  final int totalAmount;

  bool get isCompleted => status == _MockSessionStatus.completed;
}

class _MockStore {
  _MockStore._({
    required this.venues,
    required this.tables,
    required this.managers,
    required this.sessions,
    required this.now,
  });

  factory _MockStore.seed() {
    final now = DateTime.now();

    final venues = <ReportVenueModel>[
      const ReportVenueModel(id: 'v-1', name: 'Центральный филиал', number: 1),
      const ReportVenueModel(id: 'v-2', name: 'Ботаника', number: 2),
      const ReportVenueModel(id: 'v-3', name: 'Ош', number: 3),
    ];

    final tables = <_MockTable>[
      _MockTable(id: 't-1', venueId: 'v-1', number: 1, tarifAmount: 250, name: 'VIP'),
      _MockTable(id: 't-2', venueId: 'v-1', number: 2, tarifAmount: 250, name: 'VIP'),
      _MockTable(id: 't-3', venueId: 'v-1', number: 3, tarifAmount: 200, name: 'Стандарт'),
      _MockTable(id: 't-4', venueId: 'v-1', number: 4, tarifAmount: 200, name: 'Стандарт'),
      _MockTable(id: 't-5', venueId: 'v-2', number: 1, tarifAmount: 200),
      _MockTable(id: 't-6', venueId: 'v-2', number: 2, tarifAmount: 180),
      _MockTable(id: 't-7', venueId: 'v-2', number: 3, tarifAmount: 180),
      _MockTable(id: 't-8', venueId: 'v-3', number: 1, tarifAmount: 150),
      _MockTable(id: 't-9', venueId: 'v-3', number: 2, tarifAmount: 150),
    ];

    final managers = <_MockManager>[
      _MockManager(
        id: 'user-101',
        name: 'Айбек Асанов',
        username: 'aibek',
      ),
      _MockManager(
        id: 'user-102',
        name: 'Нурлан Беков',
        username: 'nurlan',
      ),
      _MockManager(
        id: 'user-103',
        name: 'Данияр Токтогул',
        username: 'daniyar',
      ),
    ];

    final rng = Random(42);
    final sessions = <_MockSession>[];
    final start = DateTime(now.year, now.month, now.day).subtract(const Duration(days: 90));

    for (var d = 0; d < 90; d++) {
      final day = start.add(Duration(days: d));
      // Weekends busier; days closer to "now" trend slightly higher.
      final weekendBoost = day.weekday >= 6 ? 1.4 : 1.0;
      final trendBoost = 0.8 + (d / 90) * 0.4;

      for (final table in tables) {
        final sessionCount = (rng.nextDouble() * 6 * weekendBoost * trendBoost).round();
        for (var s = 0; s < sessionCount; s++) {
          final manager = managers[rng.nextInt(managers.length)];
          final hour = 11 + rng.nextInt(12); // 11:00-23:00
          final startedAt = DateTime(day.year, day.month, day.day, hour, rng.nextInt(60));

          // ~3% cancellation rate, broadly applied — no per-manager bias.
          if (rng.nextDouble() < 0.03) {
            final cancelDelaySec = 10 + rng.nextInt(120);
            sessions.add(
              _MockSession(
                id: 'sess-${sessions.length}',
                tableId: table.id,
                managerId: manager.id,
                startedAt: startedAt,
                endedAt: startedAt.add(Duration(seconds: cancelDelaySec)),
                durationSeconds: 0,
                status: _MockSessionStatus.cancelled,
                totalAmount: 0,
              ),
            );
            continue;
          }

          final durationMinutes = 30 + rng.nextInt(150); // 30-180 min
          final durationSec = durationMinutes * 60;
          final endedAt = startedAt.add(Duration(seconds: durationSec));
          final total = (durationMinutes / 60.0 * table.tarifAmount).round();

          sessions.add(
            _MockSession(
              id: 'sess-${sessions.length}',
              tableId: table.id,
              managerId: manager.id,
              startedAt: startedAt,
              endedAt: endedAt,
              durationSeconds: durationSec,
              status: _MockSessionStatus.completed,
              totalAmount: total,
            ),
          );
        }
      }
    }

    return _MockStore._(
      venues: venues,
      tables: tables,
      managers: managers,
      sessions: sessions,
      now: now,
    );
  }

  final List<ReportVenueModel> venues;
  final List<_MockTable> tables;
  final List<_MockManager> managers;
  final List<_MockSession> sessions;
  final DateTime now;

  Iterable<_MockSession> _filtered(ReportRange range, {String? venueId}) {
    final tablesInScope = venueId == null
        ? tables.map((t) => t.id).toSet()
        : tables.where((t) => t.venueId == venueId).map((t) => t.id).toSet();
    return sessions.where((s) {
      if (!tablesInScope.contains(s.tableId)) return false;
      return !s.startedAt.isBefore(range.from) && s.startedAt.isBefore(range.to);
    });
  }

  ReportsSummaryModel summary(ReportRange range, {String? venueId}) {
    final scoped = _filtered(range, venueId: venueId).toList();
    final completed = scoped.where((s) => s.isCompleted).toList();
    final cancelled = scoped.where((s) => !s.isCompleted).length;

    final revenue = completed.fold<int>(0, (a, s) => a + s.totalAmount);
    final avgDuration = completed.isEmpty
        ? 0
        : completed.fold<int>(0, (a, s) => a + s.durationSeconds) ~/ completed.length;

    final tableScopeIds = venueId == null
        ? tables.map((t) => t.id).toSet()
        : tables.where((t) => t.venueId == venueId).map((t) => t.id).toSet();
    final periodSeconds = range.length.inSeconds.clamp(1, 1 << 31);
    final occupancy =
        (completed.fold<int>(0, (a, s) => a + s.durationSeconds) /
                (tableScopeIds.length * periodSeconds * 0.5)) // 12h/day working window
            .clamp(0.0, 1.0);

    return ReportsSummaryModel(
      totalRevenue: revenue,
      totalSessions: completed.length,
      cancelledSessions: cancelled,
      avgDurationSeconds: avgDuration,
      occupancyPercent: (occupancy * 100).round(),
      activeNow: 0,
      activeMax: tableScopeIds.length,
      currency: Currency.kgs,
    );
  }

  /// Period'a göre bucket boyutu:
  /// - `year` → aylık 12 nokta (mobile chart'ın okunabilir kalması için)
  /// - diğerleri → günlük (`week=7`, `month=~30`, `today=1`)
  /// (v2.1)
  List<RevenuePointModel> revenueSeries(ReportFilter filter) {
    final scoped = _filtered(
      filter.range,
      venueId: filter.venueId,
    ).where((s) => s.isCompleted).toList();

    if (filter.period == ReportPeriod.year) return _monthlyBuckets(filter, scoped);
    return _dailyBuckets(filter, scoped);
  }

  List<RevenuePointModel> _dailyBuckets(ReportFilter filter, List<_MockSession> scoped) {
    final byDay = <DateTime, _DayBucket>{};
    for (final s in scoped) {
      final key = DateTime(s.startedAt.year, s.startedAt.month, s.startedAt.day);
      byDay.putIfAbsent(key, _DayBucket.new)
        ..revenue += s.totalAmount
        ..sessions += 1;
    }
    final days = filter.range.length.inDays.clamp(1, 366);
    final start = DateTime(filter.range.from.year, filter.range.from.month, filter.range.from.day);
    return [
      for (var i = 0; i < days; i++)
        () {
          final day = start.add(Duration(days: i));
          final b = byDay[day] ?? _DayBucket();
          return RevenuePointModel(bucket: day, revenue: b.revenue, sessions: b.sessions);
        }(),
    ];
  }

  List<RevenuePointModel> _monthlyBuckets(ReportFilter filter, List<_MockSession> scoped) {
    final byMonth = <DateTime, _DayBucket>{};
    for (final s in scoped) {
      final key = DateTime(s.startedAt.year, s.startedAt.month);
      byMonth.putIfAbsent(key, _DayBucket.new)
        ..revenue += s.totalAmount
        ..sessions += 1;
    }
    // Range'in başından bitiş ayının ilk gününe kadar her ayı doldur.
    final start = DateTime(filter.range.from.year, filter.range.from.month);
    final months = <DateTime>[];
    var cursor = start;
    while (cursor.isBefore(filter.range.to)) {
      months.add(cursor);
      cursor = DateTime(cursor.year, cursor.month + 1);
    }
    return [
      for (final m in months)
        () {
          final b = byMonth[m] ?? _DayBucket();
          return RevenuePointModel(bucket: m, revenue: b.revenue, sessions: b.sessions);
        }(),
    ];
  }

  List<TableReportRowModel> tableRows(ReportFilter filter) {
    final scoped = _filtered(filter.range, venueId: filter.venueId).toList();
    // Per-table delta'da KPI delta'sıyla aynı clipped-previous mantığı.
    final prevScoped = _filtered(clippedPreviousRange(filter), venueId: filter.venueId).toList();

    final out = <TableReportRowModel>[];
    for (final t in tables) {
      if (filter.venueId != null && t.venueId != filter.venueId) continue;
      final rows = scoped.where((s) => s.tableId == t.id && s.isCompleted).toList();
      final revenue = rows.fold<int>(0, (a, s) => a + s.totalAmount);
      final prevRevenue = prevScoped
          .where((s) => s.tableId == t.id && s.isCompleted)
          .fold<int>(0, (a, s) => a + s.totalAmount);
      final avgDuration = rows.isEmpty ? 0 : rows.fold<int>(0, (a, s) => a + s.durationSeconds) ~/ rows.length;
      final periodSeconds = filter.range.length.inSeconds.clamp(1, 1 << 31);
      final occupancy = rows.fold<int>(0, (a, s) => a + s.durationSeconds) / (periodSeconds * 0.5);
      final venue = venues.firstWhere((v) => v.id == t.venueId);
      out.add(
        TableReportRowModel(
          tableId: t.id,
          tableName: t.name,
          tableNumber: t.number,
          venueId: t.venueId,
          venueName: venue.name,
          revenue: revenue,
          sessions: rows.length,
          avgDurationSeconds: avgDuration,
          occupancyPercent: (occupancy.clamp(0.0, 1.0) * 100).round(),
          currency: Currency.kgs,
          deltaPercent: prevRevenue == 0 ? null : ((revenue - prevRevenue) / prevRevenue * 100).round(),
        ),
      );
    }
    out.sort((a, b) => b.revenue.compareTo(a.revenue));
    return out;
  }

  List<ManagerReportRowModel> managerRows(ReportFilter filter) {
    final scoped = _filtered(filter.range, venueId: filter.venueId).toList();
    final out = <ManagerReportRowModel>[];

    for (final m in managers) {
      final mine = scoped.where((s) => s.managerId == m.id).toList();
      final completed = mine.where((s) => s.isCompleted).toList();
      if (completed.isEmpty) continue;
      final cancelled = mine.length - completed.length;
      out.add(
        ManagerReportRowModel(
          managerId: m.id,
          name: m.name,
          username: m.username,
          revenue: completed.fold<int>(0, (a, s) => a + s.totalAmount),
          sessions: completed.length,
          cancelCount: cancelled,
          currency: Currency.kgs,
        ),
      );
    }
    out.sort((a, b) => b.revenue.compareTo(a.revenue));
    return out;
  }

  /// Manager-detail page payload — KPI summary plus the most recent
  /// session log entries for the manager, scoped to the filter venue.
  ManagerReportDetailModel managerDetail(String managerId, ReportFilter filter) {
    final rows = managerRows(filter);
    final summary = rows.firstWhere(
      (m) => m.managerId == managerId,
      orElse: () => throw const ReportsException(ReportsErrorCode.notFound),
    );
    final scoped = _filtered(filter.range, venueId: filter.venueId).where((s) => s.managerId == managerId).toList()
      ..sort((a, b) => b.startedAt.compareTo(a.startedAt));
    final log = <ManagerSessionLogEntry>[];
    for (final s in scoped.take(40)) {
      final table = tables.firstWhere((t) => t.id == s.tableId);
      final venue = venues.firstWhere((v) => v.id == table.venueId);
      log.add(
        ManagerSessionLogEntry(
          sessionId: s.id,
          tableId: s.tableId,
          tableName: table.name,
          tableNumber: table.number,
          venueName: venue.name,
          startedAt: s.startedAt,
          endedAt: s.endedAt,
          status: s.isCompleted ? ManagerSessionLogStatus.completed : ManagerSessionLogStatus.cancelled,
          currency: Currency.kgs,
          durationSeconds: s.isCompleted ? s.durationSeconds : null,
          totalAmount: s.isCompleted ? s.totalAmount : null,
          cancelReason: s.isCompleted ? null : 'Yanlış başladım',
        ),
      );
    }
    return ManagerReportDetailModel(summary: summary, sessionLog: log);
  }

  /// Forecast for the **calendar period that the filter sits in**:
  /// linear regression on observed history extended to the end of the
  /// current calendar month/week/year. The returned `projectedTotal`
  /// includes both real-so-far revenue and projected remaining-days
  /// revenue, so the verdict reads as "this is what we'll end up with".
  /// `previousPeriodTotal` is the equivalent calendar period before
  /// (last month, last week, last year), giving a meaningful delta.
  ForecastModel forecast(ReportFilter filter) {
    final series = revenueSeries(filter);
    final actualPoints = series
        .map(
          (p) => ForecastPointModel(
            bucket: p.bucket,
            expected: p.revenue,
            lower: p.revenue,
            upper: p.revenue,
            isProjection: false,
          ),
        )
        .toList();
    if (series.isEmpty) {
      return const ForecastModel(
        points: [],
        projectedTotal: 0,
        previousPeriodTotal: 0,
        currency: Currency.kgs,
      );
    }

    // Linear regression on the historical series (slope per day).
    final n = series.length;
    var sumX = 0.0;
    var sumY = 0.0;
    var sumXY = 0.0;
    var sumX2 = 0.0;
    for (var i = 0; i < n; i++) {
      sumX += i;
      sumY += series[i].revenue;
      sumXY += i * series[i].revenue;
      sumX2 += i * i;
    }
    final slope = (n * sumXY - sumX * sumY) / max(n * sumX2 - sumX * sumX, 1);
    final intercept = (sumY - slope * sumX) / n;

    // Project from `series.last.bucket + 1 day` until the end of the
    // calendar period that matches `filter.period`. Capped at 60 to
    // keep the chart readable.
    final periodEnd = _calendarPeriodEnd(filter.period, now);
    final lastSeen = series.last.bucket;
    var projDays = periodEnd.difference(lastSeen).inDays - 1;
    if (projDays < 0) projDays = 0;
    if (projDays > 60) projDays = 60;

    final projection = <ForecastPointModel>[];
    var projTotal = 0;
    for (var i = 0; i < projDays; i++) {
      final x = n + i;
      final base = (intercept + slope * x).clamp(0, double.infinity).round();
      final day = lastSeen.add(Duration(days: i + 1));
      final boost = day.weekday >= 6 ? 1.3 : 1.0;
      final expected = (base * boost).round();
      projection.add(
        ForecastPointModel(
          bucket: day,
          expected: expected,
          lower: (expected * 0.85).round(),
          upper: (expected * 1.15).round(),
          isProjection: true,
        ),
      );
      projTotal += expected;
    }

    final realSoFar = series.fold<int>(0, (a, p) => a + p.revenue);
    final projectedTotal = realSoFar + projTotal;

    final prevRange = _previousCalendarRange(filter.period, now) ?? filter.range.previous;
    final previousTotal = summary(prevRange, venueId: filter.venueId).totalRevenue;

    return ForecastModel(
      points: [...actualPoints, ...projection],
      projectedTotal: projectedTotal,
      previousPeriodTotal: previousTotal,
      currency: Currency.kgs,
    );
  }

  /// First instant **after** the current calendar period — i.e. the
  /// boundary that the projection should end at.
  DateTime _calendarPeriodEnd(ReportPeriod period, DateTime now) {
    final today = DateTime(now.year, now.month, now.day);
    return switch (period) {
      ReportPeriod.today => today.add(const Duration(days: 1)),
      // ISO week: Monday=1, Sunday=7. End of week = next Monday 00:00.
      ReportPeriod.week => today.add(Duration(days: 8 - now.weekday)),
      ReportPeriod.month => DateTime(now.year, now.month + 1),
      ReportPeriod.year => DateTime(now.year + 1),
      ReportPeriod.custom => today.add(const Duration(days: 30)),
    };
  }

  /// "Clipped previous" — geçen takvim periyodunun **ilk N gününü** döner;
  /// burada N = current filter.range.length. KPI delta'sı bu dilimi
  /// kullanır ki periyot kapanmadan "geçen periyodun tamamı"yla
  /// karşılaştırılıp yanıltıcı düşüş sinyali vermesin. (v2.1)
  ///
  /// Periyot tamamen kapalıysa (range.to ≤ now) clipped == previousFull
  /// olur — clipping no-op.
  ReportRange clippedPreviousRange(ReportFilter filter) {
    final prevFull = _previousCalendarRange(filter.period, now) ?? filter.range.previous;
    final elapsed = filter.range.length;
    final clippedTo = prevFull.from.add(elapsed);
    return ReportRange(
      from: prevFull.from,
      to: clippedTo.isBefore(prevFull.to) ? clippedTo : prevFull.to,
    );
  }

  /// Range covering the **previous** calendar period of the same kind.
  /// `null` for `custom` — caller falls back to `filter.range.previous`.
  ReportRange? _previousCalendarRange(ReportPeriod period, DateTime now) {
    final today = DateTime(now.year, now.month, now.day);
    return switch (period) {
      ReportPeriod.today => ReportRange(
        from: today.subtract(const Duration(days: 1)),
        to: today,
      ),
      ReportPeriod.week => () {
        final thisWeekStart = today.subtract(Duration(days: now.weekday - 1));
        final prevWeekStart = thisWeekStart.subtract(const Duration(days: 7));
        return ReportRange(from: prevWeekStart, to: thisWeekStart);
      }(),
      ReportPeriod.month => ReportRange(
        from: DateTime(now.year, now.month - 1),
        to: DateTime(now.year, now.month),
      ),
      ReportPeriod.year => ReportRange(
        from: DateTime(now.year - 1),
        to: DateTime(now.year),
      ),
      ReportPeriod.custom => null,
    };
  }

  TableReportDetailModel tableDetail(String tableId, ReportFilter filter) {
    final rows = tableRows(filter);
    final summary = rows.firstWhere(
      (t) => t.tableId == tableId,
      orElse: () => throw const ReportsException(ReportsErrorCode.notFound),
    );
    final scoped = _filtered(filter.range).where((s) => s.tableId == tableId && s.isCompleted).toList();
    // revenueSeries() ile aynı bucket mantığı — yıl için aylık, diğerleri
    // için günlük. Tek farkı: scope tableId üzerine pre-filter edilmiş.
    final revenueSeries = filter.period == ReportPeriod.year
        ? _monthlyBuckets(filter, scoped)
        : _dailyBuckets(filter, scoped);

    final heatmap = List.generate(7, (_) => List<int>.filled(24, 0));
    for (final s in scoped) {
      heatmap[s.startedAt.weekday - 1][s.startedAt.hour] += s.totalAmount;
    }

    return TableReportDetailModel(
      summary: summary,
      revenueSeries: revenueSeries,
      hourHeatmap: heatmap,
    );
  }
}

class _DayBucket {
  int revenue = 0;
  int sessions = 0;
}
