import 'package:api_client/api_client.dart';
import 'package:meta/meta.dart';
import 'package:venues/venues.dart';

@immutable
final class VenueRemoteSourceImpl implements VenueRemoteSource {
  const VenueRemoteSourceImpl(this._client);

  final ApiClient _client;

  @override
  Future<List<VenueModel>> getVenues() {
    return _client.getListOfType<VenueModel>(
      '/venues',
      fromJson: VenueModel.fromJson,
    );
  }

  @override
  Future<VenueModel> getVenue(String id) {
    return _client.getType<VenueModel>(
      '/venues/$id',
      fromJson: VenueModel.fromJson,
    );
  }

  @override
  Future<VenueModel> createVenue(CreateVenueBody body) {
    return _client.postType<VenueModel>(
      '/venues',
      fromJson: VenueModel.fromJson,
      data: body.toJson(),
    );
  }

  @override
  Future<VenueModel> updateVenue(String id, UpdateVenueBody body) {
    return _client.patchType<VenueModel>(
      '/venues/$id',
      fromJson: VenueModel.fromJson,
      data: body.toJson(),
    );
  }

  @override
  Future<void> deleteVenue(String id) {
    return _client.delete('/venues/$id');
  }
}
