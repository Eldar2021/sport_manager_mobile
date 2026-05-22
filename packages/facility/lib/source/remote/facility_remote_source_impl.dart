import 'package:api_client/api_client.dart';
import 'package:facility/facility.dart';
import 'package:meta/meta.dart';

@immutable
final class FacilityRemoteSourceImpl implements FacilityRemoteSource {
  const FacilityRemoteSourceImpl(this._client);

  final ApiClient _client;

  static const _baseUrlVenue = '/api/v1/venue';
  static const _baseUrlSpot = '/api/v1/spot';

  @override
  Future<List<VenueModel>> getVenues() {
    return _client
        .getListOfType<VenueModel>(
          '$_baseUrlVenue/list',
          fromJson: VenueModel.fromJson,
        )
        .mapTo(FacilityExc.fromApiClientExc);
  }

  @override
  Future<SelectedVenueModel> getSelected() {
    return _client
        .getType<SelectedVenueModel>(
          '$_baseUrlVenue/selected',
          fromJson: SelectedVenueModel.fromJson,
        )
        .mapTo(FacilityExc.fromApiClientExc);
  }

  @override
  Future<SelectedVenueModel> updateSelected(String venueId) {
    return _client
        .patchType<SelectedVenueModel>(
          '$_baseUrlVenue/selected',
          fromJson: SelectedVenueModel.fromJson,
          data: {'venueId': venueId},
        )
        .mapTo(FacilityExc.fromApiClientExc);
  }

  @override
  Future<VenueModel> createVenue(VenueFormParam param) {
    return _client
        .postType<VenueModel>(
          '$_baseUrlVenue/create',
          fromJson: VenueModel.fromJson,
          data: param.toJson(),
        )
        .mapTo(FacilityExc.fromApiClientExc);
  }

  @override
  Future<VenueModel> updateVenue(String id, VenueFormParam param) {
    return _client
        .putType<VenueModel>(
          '$_baseUrlVenue/$id',
          fromJson: VenueModel.fromJson,
          data: param.toJson(),
        )
        .mapTo(FacilityExc.fromApiClientExc);
  }

  @override
  Future<void> deleteVenue(String id) {
    return _client.delete<void>('$_baseUrlVenue/$id').mapTo(FacilityExc.fromApiClientExc);
  }

  @override
  Future<List<SpotModel>> getVenueSpots(String venueId) {
    return _client
        .getListOfType<SpotModel>(
          '$_baseUrlVenue/$venueId/spots',
          fromJson: SpotModel.fromJson,
        )
        .mapTo(FacilityExc.fromApiClientExc);
  }

  @override
  Future<SpotModel> createSpot(SpotFormParam param) {
    return _client
        .postType<SpotModel>(
          '$_baseUrlSpot/create',
          fromJson: SpotModel.fromJson,
          data: param.toJson(),
        )
        .mapTo(FacilityExc.fromApiClientExc);
  }

  @override
  Future<SpotModel> updateSpot(
    String spotId,
    SpotFormParam param,
  ) {
    return _client
        .putType<SpotModel>(
          '$_baseUrlSpot/$spotId',
          fromJson: SpotModel.fromJson,
          data: param.toJson(),
        )
        .mapTo(FacilityExc.fromApiClientExc);
  }

  @override
  Future<void> deleteSpot(String spotId) {
    return _client
        .delete<void>('$_baseUrlSpot/$spotId')
        .mapTo(
          FacilityExc.fromApiClientExc,
        );
  }
}
