import 'package:meta/meta.dart';
import 'package:tables/tables.dart';

@immutable
final class TableRepository {
  const TableRepository({required TableRemoteSource remote}) : _remote = remote;

  final TableRemoteSource _remote;

  Future<List<TableModel>> getTables(String venueId) {
    return _remote.getTables(venueId);
  }

  Future<TableModel> getTable(String id) {
    return _remote.getTable(id);
  }

  Future<TableModel> createTable(
    String venueId,
    CreateTableBody body,
  ) {
    return _remote.createTable(venueId, body);
  }

  Future<TableModel> updateTable(
    String id,
    UpdateTableBody body,
  ) {
    return _remote.updateTable(id, body);
  }

  Future<void> deleteTable(String id) {
    return _remote.deleteTable(id);
  }
}
