import 'package:core/core.dart';
import 'package:facility/facility.dart';

final class FacilityRemoteSourceMock implements FacilityRemoteSource {
  static List<VenueModel> get _venues => MockData.venues;
  static List<SpotModel> get _spots => MockData.spots;

  String _selectedVenueId = 'venue-001';

  @override
  Future<List<VenueModel>> getVenues() async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
    return List.unmodifiable(_venues);
  }

  @override
  Future<SelectedVenueModel> getSelected() async {
    await Future<void>.delayed(const Duration(milliseconds: 700));
    final venue = _venues.firstWhere(
      (v) => v.id == _selectedVenueId,
      orElse: () => throw const FacilityExc(
        FacilityErrorCode.venueNotFound,
        message: BaseMessage(
          en: 'No venues found. Please create a venue first.',
          ru: 'Места не найдены. Пожалуйста, создайте место.',
          ky: 'Мекендер табылган жок. Алгач мекен түзүңүз.',
        ),
      ),
    );
    final spots = _spots.where((s) => s.venueId == venue.id).toList();
    return SelectedVenueModel(venue: venue, spots: spots);
  }

  @override
  Future<SelectedVenueModel> updateSelected(String venueId) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    final index = _venues.indexWhere((v) => v.id == venueId);
    if (index == -1) throw const FacilityExc(FacilityErrorCode.venueNotFound);
    _selectedVenueId = venueId;
    final updated = _venues.map((v) => _withSelected(v, v.id == venueId)).toList();
    _venues
      ..clear()
      ..addAll(updated);
    return getSelected();
  }

  @override
  Future<VenueModel> createVenue(VenueFormParam param) async {
    await Future<void>.delayed(const Duration(milliseconds: 800));
    if (_venues.any((v) => v.number == param.number)) {
      throw const FacilityExc(FacilityErrorCode.venueNumberTaken);
    }
    final isFirst = _venues.isEmpty;
    final venue = VenueModel(
      id: 'venue-${DateTime.now().millisecondsSinceEpoch}',
      name: param.name,
      number: param.number,
      type: param.type,
      address: param.address,
      selected: isFirst,
      spotCount: 0,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    _venues.add(venue);
    if (isFirst) _selectedVenueId = venue.id;
    return venue;
  }

  @override
  Future<VenueModel> updateVenue(String id, VenueFormParam param) async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
    final index = _venues.indexWhere((v) => v.id == id);
    if (index == -1) throw const FacilityExc(FacilityErrorCode.venueNotFound);
    if (_venues.any((v) => v.number == param.number && v.id != id)) {
      throw const FacilityExc(FacilityErrorCode.venueNumberTaken);
    }
    final updated = VenueModel(
      id: id,
      name: param.name,
      number: param.number,
      type: _venues[index].type,
      address: param.address,
      selected: _venues[index].selected,
      spotCount: _venues[index].spotCount,
      createdAt: _venues[index].createdAt,
      updatedAt: DateTime.now(),
    );
    _venues[index] = updated;
    return updated;
  }

  @override
  Future<void> deleteVenue(String id) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    final venue = _venues.firstWhere(
      (v) => v.id == id,
      orElse: () => throw const FacilityExc(FacilityErrorCode.venueNotFound),
    );
    final hasActiveSession = _spots.any(
      (s) => s.venueId == id && s.session != null,
    );
    if (hasActiveSession) throw const FacilityExc(FacilityErrorCode.spotHasActiveSession);
    _spots.removeWhere((s) => s.venueId == id);
    _venues.removeWhere((v) => v.id == id);
    if (venue.selected && _venues.isNotEmpty) {
      _selectedVenueId = _venues.first.id;
      _venues[0] = _withSelected(_venues.first, true);
    }
  }

  @override
  Future<List<SpotModel>> getVenueSpots(String venueId) async {
    await Future<void>.delayed(const Duration(milliseconds: 700));
    if (!_venues.any((v) => v.id == venueId)) {
      throw const FacilityExc(FacilityErrorCode.venueNotFound);
    }
    return List.unmodifiable(_spots.where((s) => s.venueId == venueId));
  }

  @override
  Future<SpotModel> createSpot(SpotFormParam param) async {
    await Future<void>.delayed(const Duration(milliseconds: 800));
    if (_spots.any((s) => s.venueId == param.venueId && s.number == param.number)) {
      throw const FacilityExc(FacilityErrorCode.spotNumberTaken);
    }
    final spot = SpotModel(
      id: 'spot-${DateTime.now().millisecondsSinceEpoch}',
      venueId: param.venueId,
      number: param.number,
      name: param.name,
      description: param.description,
      tarifAmount: param.tarifAmount,
      currency: param.currency,
      tarifType: param.tarifType,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    _spots.add(spot);
    final venueIdx = _venues.indexWhere((v) => v.id == param.venueId);
    if (venueIdx != -1) {
      final v = _venues[venueIdx];
      _venues[venueIdx] = VenueModel(
        id: v.id,
        name: v.name,
        number: v.number,
        type: v.type,
        address: v.address,
        selected: v.selected,
        spotCount: v.spotCount + 1,
        createdAt: v.createdAt,
        updatedAt: DateTime.now(),
      );
    }
    return spot;
  }

  @override
  Future<SpotModel> updateSpot(String id, SpotFormParam param) async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
    final index = _spots.indexWhere((s) => s.id == id);
    if (index == -1) throw const FacilityExc(FacilityErrorCode.spotNotFound);
    final old = _spots[index];
    if (_spots.any((s) => s.venueId == old.venueId && s.number == param.number && s.id != id)) {
      throw const FacilityExc(FacilityErrorCode.spotNumberTaken);
    }
    final updated = SpotModel(
      id: id,
      venueId: old.venueId,
      number: param.number,
      name: param.name,
      description: param.description,
      tarifAmount: param.tarifAmount,
      currency: param.currency,
      tarifType: param.tarifType,
      session: old.session,
      createdAt: old.createdAt,
      updatedAt: DateTime.now(),
    );
    _spots[index] = updated;
    return updated;
  }

  @override
  Future<void> deleteSpot(String id) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    final spot = _spots.firstWhere(
      (s) => s.id == id,
      orElse: () => throw const FacilityExc(FacilityErrorCode.spotNotFound),
    );
    if (spot.session != null) throw const FacilityExc(FacilityErrorCode.spotHasActiveSession);
    _spots.removeWhere((s) => s.id == id);
    final venueIdx = _venues.indexWhere((v) => v.id == spot.venueId);
    if (venueIdx != -1) {
      final v = _venues[venueIdx];
      _venues[venueIdx] = VenueModel(
        id: v.id,
        name: v.name,
        number: v.number,
        type: v.type,
        address: v.address,
        selected: v.selected,
        spotCount: v.spotCount - 1,
        createdAt: v.createdAt,
        updatedAt: DateTime.now(),
      );
    }
  }

  VenueModel _withSelected(VenueModel v, bool selected) => VenueModel(
    id: v.id,
    name: v.name,
    number: v.number,
    type: v.type,
    address: v.address,
    selected: selected,
    spotCount: v.spotCount,
    createdAt: v.createdAt,
    updatedAt: v.updatedAt,
  );
}
