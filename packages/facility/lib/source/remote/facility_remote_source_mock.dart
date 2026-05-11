import 'package:core/core.dart';
import 'package:facility/facility.dart';

final class FacilityRemoteSourceMock implements FacilityRemoteSource {
  static List<VenueModel> get _venues => MockData.venues;
  static List<TableModel> get _tables => MockData.tables;

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
      orElse: () => throw const FacilityException(
        FacilityErrorCode.venueNotFound,
        message: BaseMessage(
          en: 'No venues found. Please create a venue first.',
          ru: 'Места не найдены. Пожалуйста, создайте место.',
          ky: 'Мекендер табылган жок. Алгач мекен түзүңүз.',
        ),
      ),
    );
    final tables = _tables.where((t) => t.venueId == venue.id).toList();
    return SelectedVenueModel(venue: venue, tables: tables);
  }

  @override
  Future<SelectedVenueModel> updateSelected(String venueId) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    final index = _venues.indexWhere((v) => v.id == venueId);
    if (index == -1) throw const FacilityException(FacilityErrorCode.venueNotFound);
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
      throw const FacilityException(FacilityErrorCode.venueNumberTaken);
    }
    final isFirst = _venues.isEmpty;
    final venue = VenueModel(
      id: 'venue-${DateTime.now().millisecondsSinceEpoch}',
      name: param.name,
      number: param.number,
      address: param.address,
      selected: isFirst,
      tableCount: 0,
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
    if (index == -1) throw const FacilityException(FacilityErrorCode.venueNotFound);
    if (_venues.any((v) => v.number == param.number && v.id != id)) {
      throw const FacilityException(FacilityErrorCode.venueNumberTaken);
    }
    final updated = VenueModel(
      id: id,
      name: param.name,
      number: param.number,
      address: param.address,
      selected: _venues[index].selected,
      tableCount: _venues[index].tableCount,
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
      orElse: () => throw const FacilityException(FacilityErrorCode.venueNotFound),
    );
    final hasActiveSession = _tables.any(
      (t) => t.venueId == id && t.session != null,
    );
    if (hasActiveSession) throw const FacilityException(FacilityErrorCode.tableHasActiveSession);
    _tables.removeWhere((t) => t.venueId == id);
    _venues.removeWhere((v) => v.id == id);
    if (venue.selected && _venues.isNotEmpty) {
      _selectedVenueId = _venues.first.id;
      _venues[0] = _withSelected(_venues.first, true);
    }
  }

  @override
  Future<List<TableModel>> getVenueTables(String venueId) async {
    await Future<void>.delayed(const Duration(milliseconds: 700));
    if (!_venues.any((v) => v.id == venueId)) {
      throw const FacilityException(FacilityErrorCode.venueNotFound);
    }
    return List.unmodifiable(_tables.where((t) => t.venueId == venueId));
  }

  @override
  Future<TableModel> createTable(String venueId, TableFormParam param) async {
    await Future<void>.delayed(const Duration(milliseconds: 800));
    if (_tables.any((t) => t.venueId == venueId && t.number == param.number)) {
      throw const FacilityException(FacilityErrorCode.tableNumberTaken);
    }
    final table = TableModel(
      id: 'table-${DateTime.now().millisecondsSinceEpoch}',
      venueId: venueId,
      number: param.number,
      name: param.name,
      description: param.description,
      tarifAmount: param.tarifAmount,
      currency: param.currency,
      tarifType: param.tarifType,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    _tables.add(table);
    final venueIdx = _venues.indexWhere((v) => v.id == venueId);
    if (venueIdx != -1) {
      final v = _venues[venueIdx];
      _venues[venueIdx] = VenueModel(
        id: v.id,
        name: v.name,
        number: v.number,
        address: v.address,
        selected: v.selected,
        tableCount: v.tableCount + 1,
        createdAt: v.createdAt,
        updatedAt: DateTime.now(),
      );
    }
    return table;
  }

  @override
  Future<TableModel> updateTable(String id, TableFormParam param) async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
    final index = _tables.indexWhere((t) => t.id == id);
    if (index == -1) throw const FacilityException(FacilityErrorCode.tableNotFound);
    final old = _tables[index];
    if (_tables.any((t) => t.venueId == old.venueId && t.number == param.number && t.id != id)) {
      throw const FacilityException(FacilityErrorCode.tableNumberTaken);
    }
    final updated = TableModel(
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
    _tables[index] = updated;
    return updated;
  }

  @override
  Future<void> deleteTable(String id) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    final table = _tables.firstWhere(
      (t) => t.id == id,
      orElse: () => throw const FacilityException(FacilityErrorCode.tableNotFound),
    );
    if (table.session != null) throw const FacilityException(FacilityErrorCode.tableHasActiveSession);
    _tables.removeWhere((t) => t.id == id);
    final venueIdx = _venues.indexWhere((v) => v.id == table.venueId);
    if (venueIdx != -1) {
      final v = _venues[venueIdx];
      _venues[venueIdx] = VenueModel(
        id: v.id,
        name: v.name,
        number: v.number,
        address: v.address,
        selected: v.selected,
        tableCount: v.tableCount - 1,
        createdAt: v.createdAt,
        updatedAt: DateTime.now(),
      );
    }
  }

  VenueModel _withSelected(VenueModel v, bool selected) => VenueModel(
    id: v.id,
    name: v.name,
    number: v.number,
    address: v.address,
    selected: selected,
    tableCount: v.tableCount,
    createdAt: v.createdAt,
    updatedAt: v.updatedAt,
  );
}
