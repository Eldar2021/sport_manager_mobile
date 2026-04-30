import 'package:facility/facility.dart';

abstract final class MockData {
  static final now = DateTime.now();

  static final venues = <VenueModel>[
    VenueModel(
      id: 'venue-001',
      name: 'Бильярдный клуб Центр',
      number: 1,
      address: 'ул. Чуй 123, Бишкек',
      selected: true,
      tableCount: 3,
      createdAt: now.subtract(const Duration(days: 10)),
      updatedAt: now.subtract(const Duration(days: 1)),
    ),
    VenueModel(
      id: 'venue-002',
      name: 'Бильярдный клуб Восток',
      number: 2,
      address: 'ул. Манаса 45, Бишкек',
      selected: false,
      tableCount: 2,
      createdAt: now.subtract(const Duration(days: 5)),
      updatedAt: now.subtract(const Duration(days: 5)),
    ),
  ];

  static final tables = <TableModel>[
    TableModel(
      id: 'table-001',
      venueId: 'venue-001',
      number: 1,
      name: 'Стол 1',
      tarifAmount: 500,
      currency: Currency.kgs,
      tarifType: TarifType.hour,
      createdAt: now.subtract(const Duration(days: 9)),
      updatedAt: now.subtract(const Duration(days: 1)),
    ),
    TableModel(
      id: 'table-002',
      venueId: 'venue-001',
      number: 2,
      name: 'VIP Зал',
      tarifAmount: 800,
      currency: Currency.kgs,
      tarifType: TarifType.hour,
      createdAt: now.subtract(const Duration(days: 9)),
      updatedAt: now,
      session: SessionModel(
        id: 'session-001',
        tableId: 'table-002',
        status: SessionStatus.active,
        startedAt: now.subtract(const Duration(minutes: 45)),
      ),
    ),
    TableModel(
      id: 'table-003',
      venueId: 'venue-001',
      number: 3,
      tarifAmount: 500,
      currency: Currency.kgs,
      tarifType: TarifType.hour,
      createdAt: now.subtract(const Duration(days: 9)),
      updatedAt: now.subtract(const Duration(days: 9)),
    ),
    TableModel(
      id: 'table-004',
      venueId: 'venue-002',
      number: 1,
      tarifAmount: 600,
      currency: Currency.kgs,
      tarifType: TarifType.hour,
      createdAt: now.subtract(const Duration(days: 4)),
      updatedAt: now.subtract(const Duration(days: 4)),
    ),
    TableModel(
      id: 'table-005',
      venueId: 'venue-002',
      number: 2,
      tarifAmount: 600,
      currency: Currency.kgs,
      tarifType: TarifType.hour,
      createdAt: now.subtract(const Duration(days: 4)),
      updatedAt: now,
      session: SessionModel(
        id: 'session-002',
        tableId: 'table-005',
        status: SessionStatus.active,
        startedAt: now.subtract(const Duration(minutes: 20)),
      ),
    ),
  ];

  static final sessions = <String, SessionModel>{
    for (final table in tables)
      if (table.session != null) table.session!.id: table.session!,
  };

  static void updateTableSession(String tableId, SessionModel? session) {
    final index = tables.indexWhere((t) => t.id == tableId);
    if (index != -1) {
      tables[index] = tables[index].copyWith(session: session);
    }
  }
}
