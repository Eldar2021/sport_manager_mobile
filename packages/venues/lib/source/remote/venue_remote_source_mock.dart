import 'package:venues/venues.dart';

final class VenueRemoteSourceMock implements VenueRemoteSource {
  static final _venues = [
    const VenueModel(
      id: 'venue-001',
      ownerId: 'user-001',
      name: 'Бильярдный клуб Центр',
      number: '1',
      address: 'ул. Чуй 123, Бишкек',
      isActive: true,
    ),
    const VenueModel(
      id: 'venue-002',
      ownerId: 'user-001',
      name: 'Бильярдный клуб Восток',
      number: '2',
      address: 'ул. Манаса 45, Бишкек',
      isActive: true,
    ),
  ];

  @override
  Future<List<VenueModel>> getVenues() async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
    return List.unmodifiable(_venues);
  }

  @override
  Future<VenueModel> getVenue(String id) async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    return _venues.firstWhere(
      (v) => v.id == id,
      orElse: () => throw const VenueException('not_found'),
    );
  }

  @override
  Future<VenueModel> createVenue(CreateVenueBody body) async {
    await Future<void>.delayed(const Duration(milliseconds: 800));
    final venue = VenueModel(
      id: 'venue-${DateTime.now().millisecondsSinceEpoch}',
      ownerId: 'user-001',
      name: body.name,
      number: body.number,
      address: body.address,
      isActive: true,
    );
    _venues.add(venue);
    return venue;
  }

  @override
  Future<VenueModel> updateVenue(String id, UpdateVenueBody body) async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
    final index = _venues.indexWhere((v) => v.id == id);
    if (index == -1) throw const VenueException('not_found');
    final updated = VenueModel(
      id: id,
      ownerId: _venues[index].ownerId,
      name: body.name ?? _venues[index].name,
      number: body.number ?? _venues[index].number,
      address: body.address ?? _venues[index].address,
      isActive: _venues[index].isActive,
    );
    _venues[index] = updated;
    return updated;
  }

  @override
  Future<void> deleteVenue(String id) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    _venues.removeWhere((v) => v.id == id);
  }
}
