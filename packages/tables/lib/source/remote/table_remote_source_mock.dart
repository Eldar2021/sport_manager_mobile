import 'package:tables/tables.dart';

final class TableRemoteSourceMock implements TableRemoteSource {
  static final _tables = <TableModel>[
    const TableModel(
      id: 'table-001',
      venueId: 'venue-001',
      number: '1',
      name: 'Стол 1',
      hourlyRate: 500,
      status: TableStatus.available,
    ),
    const TableModel(
      id: 'table-002',
      venueId: 'venue-001',
      number: '2',
      name: 'VIP Зал',
      hourlyRate: 800,
      status: TableStatus.occupied,
    ),
    const TableModel(
      id: 'table-003',
      venueId: 'venue-001',
      number: '3',
      hourlyRate: 500,
      status: TableStatus.available,
    ),
    const TableModel(
      id: 'table-004',
      venueId: 'venue-002',
      number: '1',
      hourlyRate: 600,
      status: TableStatus.available,
    ),
    const TableModel(
      id: 'table-005',
      venueId: 'venue-002',
      number: '2',
      hourlyRate: 600,
      status: TableStatus.occupied,
    ),
  ];

  @override
  Future<List<TableModel>> getTables(String venueId) async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
    return _tables.where((t) => t.venueId == venueId).toList();
  }

  @override
  Future<TableModel> getTable(String id) async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    return _tables.firstWhere(
      (t) => t.id == id,
      orElse: () => throw const TableException('not_found'),
    );
  }

  @override
  Future<TableModel> createTable(String venueId, CreateTableBody body) async {
    await Future<void>.delayed(const Duration(milliseconds: 800));
    final table = TableModel(
      id: 'table-${DateTime.now().millisecondsSinceEpoch}',
      venueId: venueId,
      number: body.number,
      name: body.name,
      hourlyRate: body.hourlyRate,
      status: TableStatus.available,
    );
    _tables.add(table);
    return table;
  }

  @override
  Future<TableModel> updateTable(String id, UpdateTableBody body) async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
    final index = _tables.indexWhere((t) => t.id == id);
    if (index == -1) throw const TableException('not_found');
    final updated = TableModel(
      id: id,
      venueId: _tables[index].venueId,
      number: body.number ?? _tables[index].number,
      name: body.name ?? _tables[index].name,
      hourlyRate: body.hourlyRate ?? _tables[index].hourlyRate,
      status: _tables[index].status,
    );
    _tables[index] = updated;
    return updated;
  }

  @override
  Future<void> deleteTable(String id) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    _tables.removeWhere((t) => t.id == id);
  }
}
