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

  Future<List<SpotModel>> getVenueSpots(String venueId) {
    return _remote.getVenueSpots(venueId);
  }

  Future<SpotModel> createSpot(SpotFormParam param) {
    return _remote.createSpot(param);
  }

  Future<SpotModel> updateSpot(
    String spotId,
    SpotFormParam param,
  ) {
    return _remote.updateSpot(spotId, param);
  }

  Future<void> deleteSpot(String spotId) {
    return _remote.deleteSpot(spotId);
  }
}
