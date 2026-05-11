import 'package:api_client/api_client.dart';
import 'package:facility/facility.dart';
import 'package:meta/meta.dart';

@immutable
final class FacilityRemoteSourceImpl implements FacilityRemoteSource {
  const FacilityRemoteSourceImpl(this._client);

  final ApiClient _client;

  @override
  Future<List<VenueModel>> getVenues() {
    return _client
        .getListOfType<VenueModel>(
          '/api/v1/venue/list',
          fromJson: VenueModel.fromJson,
        )
        .mapTo(FacilityExc.fromApiClientExc);
  }

  @override
  Future<SelectedVenueModel> getSelected() {
    return _client
        .getType<SelectedVenueModel>(
          '/api/v1/venue/selected',
          fromJson: SelectedVenueModel.fromJson,
        )
        .mapTo(FacilityExc.fromApiClientExc);
  }

  @override
  Future<SelectedVenueModel> updateSelected(String venueId) {
    return _client
        .patchType<SelectedVenueModel>(
          '/api/v1/venue/selected',
          fromJson: SelectedVenueModel.fromJson,
          data: {'venueId': venueId},
        )
        .mapTo(FacilityExc.fromApiClientExc);
  }

  @override
  Future<VenueModel> createVenue(VenueFormParam param) {
    return _client
        .postType<VenueModel>(
          '/api/v1/venue/create',
          fromJson: VenueModel.fromJson,
          data: param.toJson(),
        )
        .mapTo(FacilityExc.fromApiClientExc);
  }

  @override
  Future<VenueModel> updateVenue(String id, VenueFormParam param) {
    return _client
        .putType<VenueModel>(
          '/api/v1/venue/$id',
          fromJson: VenueModel.fromJson,
          data: param.toJson(),
        )
        .mapTo(FacilityExc.fromApiClientExc);
  }

  @override
  Future<void> deleteVenue(String id) {
    return _client.delete<void>('/api/v1/venue/$id').mapTo(FacilityExc.fromApiClientExc);
  }

  @override
  Future<List<TableModel>> getVenueTables(String venueId) {
    return _client
        .getListOfType<TableModel>(
          '/api/v1/venue/$venueId/tables',
          fromJson: TableModel.fromJson,
        )
        .mapTo(FacilityExc.fromApiClientExc);
  }

  @override
  Future<TableModel> createTable(String venueId, TableFormParam param) {
    return _client
        .postType<TableModel>(
          '/api/v1/table/create',
          fromJson: TableModel.fromJson,
          data: {
            'venueId': venueId,
            ...param.toJson(),
          },
        )
        .mapTo(FacilityExc.fromApiClientExc);
  }

  @override
  Future<TableModel> updateTable(String tableId, TableFormParam param) {
    return _client
        .putType<TableModel>(
          '/api/v1/table/$tableId',
          fromJson: TableModel.fromJson,
          data: param.toJson(),
        )
        .mapTo(FacilityExc.fromApiClientExc);
  }

  @override
  Future<void> deleteTable(String tableId) {
    return _client.delete<void>('/api/v1/table/$tableId').mapTo(FacilityExc.fromApiClientExc);
  }
}
