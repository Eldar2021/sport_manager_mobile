import 'package:core/core.dart';
import 'package:sessions/sessions.dart';

final class SessionRemoteSourceMock implements SessionRemoteSource {
  static final _now = DateTime.now();

  static final _sessions = <SessionModel>[
    SessionModel(
      id: 'session-001',
      tableId: 'table-002',
      venueId: 'venue-001',
      managerId: 'user-001',
      startedAt: _now.subtract(const Duration(minutes: 45)),
      hourlyRateSnapshot: 800,
      discountPercent: 0,
      status: SessionStatus.active,
    ),
    SessionModel(
      id: 'session-002',
      tableId: 'table-005',
      venueId: 'venue-002',
      managerId: 'user-001',
      startedAt: _now.subtract(const Duration(minutes: 20)),
      hourlyRateSnapshot: 600,
      discountPercent: 0,
      status: SessionStatus.active,
    ),
    SessionModel(
      id: 'session-003',
      tableId: 'table-001',
      venueId: 'venue-001',
      managerId: 'user-001',
      startedAt: _now.subtract(const Duration(hours: 2)),
      endedAt: _now.subtract(const Duration(hours: 1)),
      durationSeconds: 3600,
      hourlyRateSnapshot: 500,
      subtotal: 500,
      discountPercent: 10,
      totalAmount: 450,
      status: SessionStatus.completed,
    ),
  ];

  static const _tableAlreadyOccupied = BaseMessage(
    en: 'This table already has an active session.',
    ru: 'У этого стола уже есть активная сессия.',
    ky: 'Бул столдо активдүү сессия бар.',
  );

  static const _cancelWindowExpired = BaseMessage(
    en: 'Cancel window has expired (60 seconds).',
    ru: 'Окно отмены истекло (60 секунд).',
    ky: 'Жокко чыгаруу убактысы өттү (60 секунд).',
  );

  @override
  Future<SessionModel> startSession(String tableId) async {
    await Future<void>.delayed(const Duration(milliseconds: 700));

    final occupied = _sessions.any((s) => s.tableId == tableId && s.isActive);
    if (occupied) {
      throw const SessionException('TABLE_ALREADY_OCCUPIED', message: _tableAlreadyOccupied);
    }

    final session = SessionModel(
      id: 'session-${DateTime.now().millisecondsSinceEpoch}',
      tableId: tableId,
      venueId: 'venue-001',
      managerId: 'user-001',
      startedAt: DateTime.now(),
      hourlyRateSnapshot: 500,
      discountPercent: 0,
      status: SessionStatus.active,
    );
    _sessions.add(session);
    return session;
  }

  @override
  Future<void> cancelSession(String id) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));

    final index = _sessions.indexWhere((s) => s.id == id);
    if (index == -1) throw const SessionException('not_found');

    final session = _sessions[index];
    final elapsed = DateTime.now().difference(session.startedAt).inSeconds;
    if (elapsed > 60) {
      throw const SessionException('CANCEL_WINDOW_EXPIRED', message: _cancelWindowExpired);
    }

    _sessions[index] = SessionModel(
      id: session.id,
      tableId: session.tableId,
      venueId: session.venueId,
      managerId: session.managerId,
      startedAt: session.startedAt,
      endedAt: DateTime.now(),
      hourlyRateSnapshot: session.hourlyRateSnapshot,
      discountPercent: 0,
      status: SessionStatus.cancelled,
    );
  }

  @override
  Future<SessionModel> endSession(String id, EndSessionBody body) async {
    await Future<void>.delayed(const Duration(milliseconds: 700));

    final index = _sessions.indexWhere((s) => s.id == id);
    if (index == -1) throw const SessionException('not_found');

    final session = _sessions[index];
    final endedAt = DateTime.now();
    final durationSeconds = endedAt.difference(session.startedAt).inSeconds;
    final durationHours = durationSeconds / 3600;
    final subtotal = (durationHours * session.hourlyRateSnapshot).round();
    final discount = body.discountPercent ?? 0;
    final totalAmount = (subtotal * (100 - discount) / 100).round();

    final completed = SessionModel(
      id: session.id,
      tableId: session.tableId,
      venueId: session.venueId,
      managerId: session.managerId,
      startedAt: session.startedAt,
      endedAt: endedAt,
      durationSeconds: durationSeconds,
      hourlyRateSnapshot: session.hourlyRateSnapshot,
      subtotal: subtotal,
      discountPercent: discount,
      totalAmount: totalAmount,
      status: SessionStatus.completed,
    );
    _sessions[index] = completed;
    return completed;
  }

  @override
  Future<List<SessionModel>> getActiveSessions() async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    return _sessions.where((s) => s.isActive).toList();
  }

  @override
  Future<SessionsResponse> getSessions(SessionsQuery query) async {
    await Future<void>.delayed(const Duration(milliseconds: 600));

    final filtered = _sessions.where((s) {
      if (query.venueId != null && s.venueId != query.venueId) return false;
      if (query.tableId != null && s.tableId != query.tableId) return false;
      if (query.managerId != null && s.managerId != query.managerId) return false;
      if (query.status != null && s.status != query.status) return false;
      if (query.from != null && s.startedAt.isBefore(query.from!)) return false;
      if (query.to != null && s.startedAt.isAfter(query.to!)) return false;
      return true;
    }).toList();

    final page = query.page ?? 1;
    final limit = query.limit ?? 20;
    final total = filtered.length;
    final start = (page - 1) * limit;
    final items = filtered.skip(start).take(limit).toList();

    return SessionsResponse(items: items, total: total, page: page, limit: limit);
  }
}
