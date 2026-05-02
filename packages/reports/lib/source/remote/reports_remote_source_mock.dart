import 'dart:math';

import 'package:facility/facility.dart';
import 'package:reports/reports.dart';

/// Synthetic data store used while the backend is not yet wired. Generates
/// ~90 days of session-level data so every report endpoint has something
/// realistic (and a manager seeded with fraud-signal patterns) to render.
final class ReportsRemoteSourceMock implements ReportsRemoteSource {
  ReportsRemoteSourceMock() : _store = _MockStore.seed();

  static const _delay = Duration(milliseconds: 400);

  final _MockStore _store;
  final Set<String> _dismissed = <String>{};

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

    final previous = _store.summary(
      filter.range.previous,
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
  Future<List<TableReportRowModel>> getTopTables(
    ReportFilter filter, {
    int limit = 5,
  }) async {
    await Future<void>.delayed(_delay);
    final rows = _store.tableRows(filter)..sort((a, b) => b.revenue.compareTo(a.revenue));
    return rows.take(limit).toList(growable: false);
  }

  @override
  Future<List<ManagerReportRowModel>> getManagers(ReportFilter filter) async {
    await Future<void>.delayed(_delay);
    return _store.managerRows(filter);
  }

  @override
  Future<List<InsightModel>> getInsights(ReportFilter filter) async {
    await Future<void>.delayed(_delay);
    return _store.insights(filter).where((i) => !_dismissed.contains(i.id)).toList(growable: false);
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

  @override
  Future<void> dismissInsight(String id) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    _dismissed.add(id);
  }
}

// ───────────────────────── synthetic data engine ─────────────────────────

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
    required this.honesty,
    required this.discountBias,
  });
  final String id;
  final String name;
  final String username;

  /// 0.0 = saint, 1.0 = bandit. Used to bias cancel/short/off-hours rates.
  final double honesty;

  /// 0.0 = no discount, 1.0 = always discounts heavily. Independent signal.
  final double discountBias;
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
    required this.discountPercent,
    this.cancelReason,
  });
  final String id;
  final String tableId;
  final String managerId;
  final DateTime startedAt;
  final DateTime endedAt;
  final int durationSeconds;
  final ManagerSessionLogStatus status;
  final int totalAmount;
  final int discountPercent;
  final String? cancelReason;
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
        honesty: 0.9, // bandit pattern
        discountBias: 0.7,
      ),
      _MockManager(
        id: 'user-102',
        name: 'Нурлан Беков',
        username: 'nurlan',
        honesty: 0.05,
        discountBias: 0.05,
      ),
      _MockManager(
        id: 'user-103',
        name: 'Данияр Токтогул',
        username: 'daniyar',
        honesty: 0.2,
        discountBias: 0.15,
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
        // Around 4 sessions per table per day on average, scaled.
        final sessionCount = (rng.nextDouble() * 6 * weekendBoost * trendBoost).round();
        for (var s = 0; s < sessionCount; s++) {
          final manager = managers[rng.nextInt(managers.length)];
          // Mostly daytime, but bandits drift into off-hours.
          final hour = manager.honesty > 0.5 && rng.nextDouble() < 0.15
              ? 1 +
                    rng.nextInt(6) // 01:00-07:00 → off-hours signal
              : 11 + rng.nextInt(12); // 11:00-23:00
          final startedAt = DateTime(day.year, day.month, day.day, hour, rng.nextInt(60));

          // CANCELLED bias: bandits cancel a lot, especially under 60s.
          final cancelChance = 0.02 + manager.honesty * 0.10;
          if (rng.nextDouble() < cancelChance) {
            final cancelDelaySec = manager.honesty > 0.5 && rng.nextDouble() < 0.7
                ? rng.nextInt(55) // within 60s window
                : 60 + rng.nextInt(600);
            sessions.add(
              _MockSession(
                id: 'sess-${sessions.length}',
                tableId: table.id,
                managerId: manager.id,
                startedAt: startedAt,
                endedAt: startedAt.add(Duration(seconds: cancelDelaySec)),
                durationSeconds: 0,
                status: ManagerSessionLogStatus.cancelled,
                totalAmount: 0,
                discountPercent: 0,
                cancelReason: cancelDelaySec < 60 ? 'Yanlış başladım' : 'Müşteri vazgeçti',
              ),
            );
            continue;
          }

          // Short-session cluster bias for bandits.
          final isShortFraud = manager.honesty > 0.5 && rng.nextDouble() < 0.12;
          final durationMinutes = isShortFraud
              ? 1 +
                    rng.nextInt(4) // <5 min
              : 30 + rng.nextInt(150); // 30-180 min
          final durationSec = durationMinutes * 60;
          final endedAt = startedAt.add(Duration(seconds: durationSec));

          // Discount bias.
          final hasDiscount = rng.nextDouble() < (0.05 + manager.discountBias * 0.4);
          final discountPercent = hasDiscount ? (5 + rng.nextInt(25)) : 0;
          final subtotal = (durationMinutes / 60.0 * table.tarifAmount).round();
          final total = (subtotal * (100 - discountPercent) / 100).round();

          sessions.add(
            _MockSession(
              id: 'sess-${sessions.length}',
              tableId: table.id,
              managerId: manager.id,
              startedAt: startedAt,
              endedAt: endedAt,
              durationSeconds: durationSec,
              status: ManagerSessionLogStatus.completed,
              totalAmount: total,
              discountPercent: discountPercent,
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
    final completed = scoped.where((s) => s.status == ManagerSessionLogStatus.completed).toList();
    final cancelled = scoped.where((s) => s.status == ManagerSessionLogStatus.cancelled).length;

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

  List<RevenuePointModel> revenueSeries(ReportFilter filter) {
    final scoped = _filtered(
      filter.range,
      venueId: filter.venueId,
    ).where((s) => s.status == ManagerSessionLogStatus.completed).toList();
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

  List<TableReportRowModel> tableRows(ReportFilter filter) {
    final scoped = _filtered(filter.range, venueId: filter.venueId).toList();
    final prevScoped = _filtered(filter.range.previous, venueId: filter.venueId).toList();

    final out = <TableReportRowModel>[];
    for (final t in tables) {
      if (filter.venueId != null && t.venueId != filter.venueId) continue;
      final rows = scoped.where((s) => s.tableId == t.id && s.status == ManagerSessionLogStatus.completed).toList();
      if (rows.isEmpty) continue;
      final revenue = rows.fold<int>(0, (a, s) => a + s.totalAmount);
      final prevRevenue = prevScoped
          .where((s) => s.tableId == t.id && s.status == ManagerSessionLogStatus.completed)
          .fold<int>(0, (a, s) => a + s.totalAmount);
      final avgDuration = rows.fold<int>(0, (a, s) => a + s.durationSeconds) ~/ rows.length;
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

    // Compute team-level benchmarks first.
    var totalCompleted = 0;
    var totalCancel = 0;
    var totalDiscounted = 0;
    var totalDiscountPct = 0;
    for (final s in scoped) {
      if (s.status == ManagerSessionLogStatus.cancelled) {
        totalCancel++;
      } else {
        totalCompleted++;
        if (s.discountPercent > 0) {
          totalDiscounted++;
          totalDiscountPct += s.discountPercent;
        }
      }
    }
    final teamCancelRate = totalCompleted + totalCancel == 0 ? 0.0 : totalCancel / (totalCompleted + totalCancel);
    final teamDiscountRate = totalCompleted == 0 ? 0.0 : totalDiscounted / totalCompleted;
    final teamAvgDiscount = totalDiscounted == 0 ? 0.0 : totalDiscountPct / totalDiscounted;

    for (final m in managers) {
      final mine = scoped.where((s) => s.managerId == m.id).toList();
      if (mine.isEmpty) continue;
      final completed = mine.where((s) => s.status == ManagerSessionLogStatus.completed).toList();
      final cancelled = mine.where((s) => s.status == ManagerSessionLogStatus.cancelled).toList();
      final cancel60s = cancelled.where((s) => s.endedAt.difference(s.startedAt).inSeconds < 60).length;
      final shortSessions = completed.where((s) => s.durationSeconds < 5 * 60).length;
      final offHours = mine.where((s) => s.startedAt.hour < 8).length;
      final discounted = completed.where((s) => s.discountPercent > 0).toList();
      final myCancelRate = mine.isEmpty ? 0.0 : cancelled.length / mine.length;
      final myDiscountRate = completed.isEmpty ? 0.0 : discounted.length / completed.length;
      final myAvgDiscount = discounted.isEmpty
          ? 0.0
          : discounted.fold<int>(0, (a, s) => a + s.discountPercent) / discounted.length;

      final flags = <FraudFlagModel>[];
      if (myCancelRate > 2 * teamCancelRate && myCancelRate > 0.05) {
        flags.add(
          FraudFlagModel(
            code: FraudFlagCode.highCancelRate,
            severity: InsightSeverity.critical,
            value: myCancelRate,
            benchmark: teamCancelRate,
          ),
        );
      }
      if (cancel60s > 5) {
        flags.add(
          FraudFlagModel(
            code: FraudFlagCode.highCancel60s,
            severity: InsightSeverity.critical,
            value: cancel60s.toDouble(),
            benchmark: 2,
          ),
        );
      }
      if (myDiscountRate > 2 * teamDiscountRate && myDiscountRate > 0.10) {
        flags.add(
          FraudFlagModel(
            code: FraudFlagCode.highDiscountRate,
            severity: InsightSeverity.warning,
            value: myDiscountRate,
            benchmark: teamDiscountRate,
          ),
        );
      }
      if (myAvgDiscount > 15) {
        flags.add(
          FraudFlagModel(
            code: FraudFlagCode.highAvgDiscount,
            severity: InsightSeverity.warning,
            value: myAvgDiscount,
            benchmark: max(teamAvgDiscount, 1),
          ),
        );
      }
      if (offHours > 0) {
        flags.add(
          FraudFlagModel(
            code: FraudFlagCode.offHoursActivity,
            severity: InsightSeverity.warning,
            value: offHours.toDouble(),
            benchmark: 0,
          ),
        );
      }
      if (shortSessions > 5 && completed.isNotEmpty && shortSessions / completed.length > 0.10) {
        flags.add(
          FraudFlagModel(
            code: FraudFlagCode.shortSessionCluster,
            severity: InsightSeverity.warning,
            value: shortSessions.toDouble(),
            benchmark: max(completed.length * 0.05, 1),
          ),
        );
      }

      final score = flags.fold<int>(0, (acc, f) {
        return acc +
            switch (f.severity) {
              InsightSeverity.critical => 35,
              InsightSeverity.warning => 18,
              InsightSeverity.info => 6,
            };
      });
      final clamped = score.clamp(0, 100);
      final band = clamped >= 60
          ? ManagerRiskBand.red
          : clamped >= 30
          ? ManagerRiskBand.yellow
          : ManagerRiskBand.green;

      out.add(
        ManagerReportRowModel(
          managerId: m.id,
          name: m.name,
          username: m.username,
          revenue: completed.fold(0, (a, s) => a + s.totalAmount),
          sessions: completed.length,
          cancelCount: cancelled.length,
          discountedCount: discounted.length,
          avgDiscountPercent: myAvgDiscount.round(),
          riskScore: clamped,
          riskBand: band,
          flags: flags,
          currency: Currency.kgs,
        ),
      );
    }
    out.sort((a, b) => b.revenue.compareTo(a.revenue));
    return out;
  }

  List<InsightModel> insights(ReportFilter filter) {
    final out = <InsightModel>[];
    final managers = managerRows(filter);
    for (final m in managers) {
      if (m.riskBand == ManagerRiskBand.red) {
        out.add(
          InsightModel(
            id: 'insight-mgr-${m.managerId}-${filter.range.from.toIso8601String()}',
            severity: InsightSeverity.critical,
            title: const {
              'en': 'Manager needs review',
              'ru': 'Менеджер требует внимания',
              'ky': 'Менеджерди карап чыгуу керек',
            },
            body: {
              'en': '${m.name}: ${m.cancelCount} cancels, ${m.flags.length} risk signals',
              'ru': '${m.name}: ${m.cancelCount} отмен, ${m.flags.length} сигналов риска',
              'ky': '${m.name}: ${m.cancelCount} жокко чыгаруу, ${m.flags.length} тобокел сигналы',
            },
            createdAt: now,
            acknowledged: false,
            action: InsightAction(type: InsightActionType.managerDetail, targetId: m.managerId),
          ),
        );
      }
    }

    // Tables in long decline.
    final tableRowsList = tableRows(filter);
    for (final t in tableRowsList.take(2)) {
      if ((t.deltaPercent ?? 0) <= -20) {
        out.add(
          InsightModel(
            id: 'insight-tbl-${t.tableId}-${filter.range.from.toIso8601String()}',
            severity: InsightSeverity.warning,
            title: const {
              'en': 'Table revenue dropping',
              'ru': 'Доход стола падает',
              'ky': 'Стол кирешеси түшүп жатат',
            },
            body: {
              'en': '${t.venueName} · #${t.tableNumber}: ${t.deltaPercent}% vs previous',
              'ru': '${t.venueName} · №${t.tableNumber}: ${t.deltaPercent}% к прошлому',
              'ky': '${t.venueName} · №${t.tableNumber}: ${t.deltaPercent}% мурунку менен',
            },
            createdAt: now,
            acknowledged: false,
            action: InsightAction(type: InsightActionType.tableDetail, targetId: t.tableId),
          ),
        );
      }
    }
    return out;
  }

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
    // Linear regression over the visible window.
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
    const projDays = 14;
    final projection = <ForecastPointModel>[];
    var projTotal = 0;
    for (var i = 0; i < projDays; i++) {
      final x = n + i;
      final base = (intercept + slope * x).clamp(0, double.infinity).round();
      // Simple weekend boost.
      final day = series.last.bucket.add(Duration(days: i + 1));
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
    final prevSummary = summary(filter.range.previous, venueId: filter.venueId);
    return ForecastModel(
      points: [...actualPoints, ...projection],
      projectedTotal: projTotal,
      previousPeriodTotal: prevSummary.totalRevenue,
      currency: Currency.kgs,
    );
  }

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
          status: s.status,
          currency: Currency.kgs,
          durationSeconds: s.status == ManagerSessionLogStatus.completed ? s.durationSeconds : null,
          totalAmount: s.status == ManagerSessionLogStatus.completed ? s.totalAmount : null,
          discountPercent: s.status == ManagerSessionLogStatus.completed ? s.discountPercent : null,
          cancelReason: s.cancelReason,
        ),
      );
    }
    return ManagerReportDetailModel(summary: summary, sessionLog: log);
  }

  TableReportDetailModel tableDetail(String tableId, ReportFilter filter) {
    final rows = tableRows(filter);
    final summary = rows.firstWhere(
      (t) => t.tableId == tableId,
      orElse: () => throw const ReportsException(ReportsErrorCode.notFound),
    );
    final scoped = _filtered(
      filter.range,
    ).where((s) => s.tableId == tableId && s.status == ManagerSessionLogStatus.completed).toList();
    final byDay = <DateTime, _DayBucket>{};
    for (final s in scoped) {
      final key = DateTime(s.startedAt.year, s.startedAt.month, s.startedAt.day);
      byDay.putIfAbsent(key, _DayBucket.new)
        ..revenue += s.totalAmount
        ..sessions += 1;
    }
    final days = filter.range.length.inDays.clamp(1, 366);
    final start = DateTime(filter.range.from.year, filter.range.from.month, filter.range.from.day);
    final revenueByDay = [
      for (var i = 0; i < days; i++)
        () {
          final day = start.add(Duration(days: i));
          final b = byDay[day] ?? _DayBucket();
          return RevenuePointModel(bucket: day, revenue: b.revenue, sessions: b.sessions);
        }(),
    ];

    final heatmap = List.generate(7, (_) => List<int>.filled(24, 0));
    for (final s in scoped) {
      heatmap[s.startedAt.weekday - 1][s.startedAt.hour] += s.totalAmount;
    }

    return TableReportDetailModel(summary: summary, revenueByDay: revenueByDay, hourHeatmap: heatmap);
  }
}

class _DayBucket {
  int revenue = 0;
  int sessions = 0;
}
