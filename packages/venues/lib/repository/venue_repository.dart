import 'package:meta/meta.dart';
import 'package:venues/venues.dart';

@immutable
final class VenueRepository {
  const VenueRepository({required VenueRemoteSource remote}) : _remote = remote;

  final VenueRemoteSource _remote;

  Future<List<VenueModel>> getVenues() {
    return _remote.getVenues();
  }

  Future<VenueModel> getVenue(String id) {
    return _remote.getVenue(id);
  }

  Future<VenueModel> createVenue(CreateVenueBody body) {
    return _remote.createVenue(body);
  }

  Future<VenueModel> updateVenue(
    String id,
    UpdateVenueBody body,
  ) {
    return _remote.updateVenue(id, body);
  }

  Future<void> deleteVenue(String id) {
    return _remote.deleteVenue(id);
  }
}
