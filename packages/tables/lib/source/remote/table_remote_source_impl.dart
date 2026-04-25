import 'package:api_client/api_client.dart';
import 'package:meta/meta.dart';
import 'package:tables/tables.dart';

@immutable
final class TableRemoteSourceImpl implements TableRemoteSource {
  const TableRemoteSourceImpl(this._client);

  final ApiClient _client;

  @override
  Future<List<TableModel>> getTables(String venueId) {
    return _client.getListOfType<TableModel>(
      '/venues/$venueId/tables',
      fromJson: TableModel.fromJson,
    );
  }

  @override
  Future<TableModel> getTable(String id) {
    return _client.getType<TableModel>(
      '/tables/$id',
      fromJson: TableModel.fromJson,
    );
  }

  @override
  Future<TableModel> createTable(String venueId, CreateTableBody body) {
    return _client.postType<TableModel>(
      '/venues/$venueId/tables',
      fromJson: TableModel.fromJson,
      data: body.toJson(),
    );
  }

  @override
  Future<TableModel> updateTable(String id, UpdateTableBody body) {
    return _client.patchType<TableModel>(
      '/tables/$id',
      fromJson: TableModel.fromJson,
      data: body.toJson(),
    );
  }

  @override
  Future<void> deleteTable(String id) {
    return _client.delete('/tables/$id');
  }
}
