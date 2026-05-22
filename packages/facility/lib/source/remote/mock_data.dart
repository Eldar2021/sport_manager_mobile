import 'package:facility/facility.dart';

abstract final class MockData {
  static final now = DateTime.now();

  static final venues = <VenueModel>[
    VenueModel(
      id: 'venue-001',
      name: 'Бильярдный клуб Центр',
      number: 1,
      type: VenueType.billiards,
      address: 'ул. Чуй 123, Бишкек',
      selected: true,
      spotCount: 3,
      createdAt: now.subtract(const Duration(days: 10)),
      updatedAt: now.subtract(const Duration(days: 1)),
    ),
    VenueModel(
      id: 'venue-002',
      name: 'Бильярдный клуб Восток',
      number: 2,
      type: VenueType.billiards,
      address: 'ул. Манаса 45, Бишкек',
      selected: false,
      spotCount: 2,
      createdAt: now.subtract(const Duration(days: 5)),
      updatedAt: now.subtract(const Duration(days: 5)),
    ),
  ];

  static final spots = <SpotModel>[
    SpotModel(
      id: 'spot-001',
      venueId: 'venue-001',
      number: 1,
      name: 'Стол 1',
      tarifAmount: 500,
      currency: Currency.kgs,
      tarifType: TarifType.hour,
      createdAt: now.subtract(const Duration(days: 9)),
      updatedAt: now.subtract(const Duration(days: 1)),
    ),
    SpotModel(
      id: 'spot-002',
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
        spotId: 'spot-002',
        status: SessionStatus.active,
        startedAt: now.subtract(const Duration(minutes: 45)),
      ),
    ),
    SpotModel(
      id: 'spot-003',
      venueId: 'venue-001',
      number: 3,
      tarifAmount: 500,
      currency: Currency.kgs,
      tarifType: TarifType.hour,
      createdAt: now.subtract(const Duration(days: 9)),
      updatedAt: now.subtract(const Duration(days: 9)),
    ),
    SpotModel(
      id: 'spot-004',
      venueId: 'venue-002',
      number: 1,
      tarifAmount: 600,
      currency: Currency.kgs,
      tarifType: TarifType.hour,
      createdAt: now.subtract(const Duration(days: 4)),
      updatedAt: now.subtract(const Duration(days: 4)),
    ),
    SpotModel(
      id: 'spot-005',
      venueId: 'venue-002',
      number: 2,
      tarifAmount: 600,
      currency: Currency.kgs,
      tarifType: TarifType.hour,
      createdAt: now.subtract(const Duration(days: 4)),
      updatedAt: now,
      session: SessionModel(
        id: 'session-002',
        spotId: 'spot-005',
        status: SessionStatus.active,
        startedAt: now.subtract(const Duration(minutes: 20)),
      ),
    ),
  ];

  static final sessions = <String, SessionModel>{
    for (final spot in spots)
      if (spot.session != null) spot.session!.id: spot.session!,
  };

  static void updateSpotSession(String spotId, SessionModel? session) {
    final index = spots.indexWhere((s) => s.id == spotId);
    if (index != -1) {
      spots[index] = spots[index].copyWith(session: session);
    }
  }
}
