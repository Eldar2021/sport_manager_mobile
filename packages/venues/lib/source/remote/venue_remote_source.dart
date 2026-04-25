import 'package:venues/venues.dart';

abstract interface class VenueRemoteSource {
  Future<List<VenueModel>> getVenues();

  Future<VenueModel> getVenue(String id);

  Future<VenueModel> createVenue(CreateVenueBody body);

  Future<VenueModel> updateVenue(String id, UpdateVenueBody body);

  Future<void> deleteVenue(String id);
}
