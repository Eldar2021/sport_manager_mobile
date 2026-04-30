import 'package:managers/managers.dart';

abstract interface class ManagerRemoteSource {
  Future<List<ManagerModel>> getManagers();

  Future<void> deleteManager(String id);
}
