import 'package:managers/managers.dart';
import 'package:meta/meta.dart';

@immutable
final class ManagerRepository {
  const ManagerRepository(this._remote);

  final ManagerRemoteSource _remote;

  Future<List<ManagerModel>> getManagers() {
    return _remote.getManagers();
  }

  Future<void> deleteManager(String id) {
    return _remote.deleteManager(id);
  }
}
