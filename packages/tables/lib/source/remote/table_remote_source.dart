import 'package:tables/tables.dart';

abstract interface class TableRemoteSource {
  Future<List<TableModel>> getTables(String venueId);

  Future<TableModel> getTable(String id);

  Future<TableModel> createTable(String venueId, CreateTableBody body);

  Future<TableModel> updateTable(String id, UpdateTableBody body);

  Future<void> deleteTable(String id);
}
