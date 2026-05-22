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

  Future<List<SpotModel>> getVenueSpots(String venueId);

  Future<SpotModel> createSpot(SpotFormParam param);

  Future<SpotModel> updateSpot(
    String spotId,
    SpotFormParam param,
  );

  Future<void> deleteSpot(String spotId);
}
