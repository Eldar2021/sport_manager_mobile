import 'package:api_client/api_client.dart';
import 'package:facility/facility.dart';
import 'package:meta/meta.dart';

@immutable
final class FacilityRemoteSourceImpl implements FacilityRemoteSource {
  const FacilityRemoteSourceImpl(this._client);

  final ApiClient _client;

  static const String _baseUrlVenue = '/api/v1/venue';
  static const String _baseUrlTable = '/api/v1/table';

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
  Future<List<TableModel>> getVenueTables(String venueId) {
    return _client
        .getListOfType<TableModel>(
          '$_baseUrlVenue/$venueId/tables',
          fromJson: TableModel.fromJson,
        )
        .mapTo(FacilityExc.fromApiClientExc);
  }

  @override
  Future<TableModel> createTable(TableFormParam param) {
    return _client
        .postType<TableModel>(
          '$_baseUrlTable/create',
          fromJson: TableModel.fromJson,
          data: param.toJson(),
        )
        .mapTo(FacilityExc.fromApiClientExc);
  }

  @override
  Future<TableModel> updateTable(
    String tableId,
    TableFormParam param,
  ) {
    return _client
        .putType<TableModel>(
          '$_baseUrlTable/$tableId',
          fromJson: TableModel.fromJson,
          data: param.toJson(),
        )
        .mapTo(FacilityExc.fromApiClientExc);
  }

  @override
  Future<void> deleteTable(String tableId) {
    return _client
        .delete<void>('$_baseUrlTable/$tableId')
        .mapTo(
          FacilityExc.fromApiClientExc,
        );
  }
}
