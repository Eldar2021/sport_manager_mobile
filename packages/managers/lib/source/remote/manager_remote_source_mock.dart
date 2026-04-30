import 'package:managers/managers.dart';

final class ManagerRemoteSourceMock implements ManagerRemoteSource {
  static final _now = DateTime.now();

  static final _managers = <ManagerModel>[
    ManagerModel(
      id: 'user-101',
      name: 'Айбек Асанов',
      username: 'aibek',
      lastSeenAt: _now.subtract(const Duration(minutes: 10)),
    ),
    ManagerModel(
      id: 'user-102',
      name: 'Нурлан Беков',
      username: 'nurlan',
      lastSeenAt: _now.subtract(const Duration(days: 2)),
    ),
    ManagerModel(
      id: 'user-103',
      name: 'Данияр Токтогул',
      username: 'daniyar',
      lastSeenAt: _now.subtract(const Duration(days: 1)),
    ),
  ];

  @override
  Future<List<ManagerModel>> getManagers() async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
    return List.unmodifiable(_managers);
  }

  @override
  Future<void> deleteManager(String id) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    final index = _managers.indexWhere((m) => m.id == id);
    if (index == -1) throw const ManagerException(ManagerErrorCode.notFound);
    _managers.removeAt(index);
  }
}
