import 'package:api_client/api_client.dart';
import 'package:managers/managers.dart';
import 'package:meta/meta.dart';

@immutable
final class ManagerRemoteSourceImpl implements ManagerRemoteSource {
  const ManagerRemoteSourceImpl(this._client);

  final ApiClient _client;

  @override
  Future<List<ManagerModel>> getManagers() {
    return _client.getListOfType<ManagerModel>(
      '/api/v1/managers',
      fromJson: ManagerModel.fromJson,
    );
  }

  @override
  Future<void> deleteManager(String id) {
    return _client.delete('/api/v1/managers/$id');
  }
}
