import 'package:facility/facility.dart';

abstract interface class FacilityRemoteSource {
  Future<List<VenueModel>> getVenues();

  Future<SelectedVenueModel> getSelected();

  Future<SelectedVenueModel> updateSelected(String venueId);

  Future<VenueModel> createVenue(VenueFormParam param);

  Future<VenueModel> updateVenue(
    String id,
    VenueFormParam param,
  );

  Future<void> deleteVenue(String id);

  Future<List<TableModel>> getVenueTables(String venueId);

  Future<TableModel> createTable(TableFormParam param);

  Future<TableModel> updateTable(
    String tableId,
    TableFormParam param,
  );

  Future<void> deleteTable(String tableId);
}
