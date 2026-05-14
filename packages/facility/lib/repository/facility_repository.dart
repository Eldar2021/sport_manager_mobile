import 'package:facility/facility.dart';
import 'package:meta/meta.dart';

@immutable
final class FacilityRepository {
  const FacilityRepository(this._remote);

  final FacilityRemoteSource _remote;

  Future<List<VenueModel>> getVenues() {
    return _remote.getVenues();
  }

  Future<SelectedVenueModel> getSelected() {
    return _remote.getSelected();
  }

  Future<SelectedVenueModel> updateSelected(String venueId) {
    return _remote.updateSelected(venueId);
  }

  Future<VenueModel> createVenue(VenueFormParam param) {
    return _remote.createVenue(param);
  }

  Future<VenueModel> updateVenue(String id, VenueFormParam param) {
    return _remote.updateVenue(id, param);
  }

  Future<void> deleteVenue(String id) {
    return _remote.deleteVenue(id);
  }

  Future<List<TableModel>> getVenueTables(String venueId) {
    return _remote.getVenueTables(venueId);
  }

  Future<TableModel> createTable(TableFormParam param) {
    return _remote.createTable(param);
  }

  Future<TableModel> updateTable(
    String tableId,
    TableFormParam param,
  ) {
    return _remote.updateTable(tableId, param);
  }

  Future<void> deleteTable(String tableId) {
    return _remote.deleteTable(tableId);
  }
}
