import 'package:api_client/api_client.dart';
import 'package:facility/facility.dart';
import 'package:meta/meta.dart';

@immutable
final class FacilityRepository {
  const FacilityRepository(this._remote);

  final FacilityRemoteSource _remote;

  Future<List<VenueModel>> getVenues() {
    try {
      return _remote.getVenues();
    } on ApiClientException catch (e) {
      throw switch (e.error.response?.data) {
        'VENUE_NOT_FOUND' => const VenueException(VenueErrorCode.notFound),
        'VENUE_NUMBER_TAKEN' => const VenueException(VenueErrorCode.numberTaken),
        'VENUE_HAS_TABLES' => const VenueException(VenueErrorCode.hasTables),
        'VENUE_FORBIDDEN' => const VenueException(VenueErrorCode.forbidden),
        _ => const VenueException(VenueErrorCode.unknown),
      };
    }
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

  Future<TableModel> createTable(
    String venueId,
    TableFormParam param,
  ) {
    return _remote.createTable(venueId, param);
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
