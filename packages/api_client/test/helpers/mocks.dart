import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:mocktail/mocktail.dart';

class MockConnectivity extends Mock implements Connectivity {
  MockConnectivity();

  @override
  Future<List<ConnectivityResult>> checkConnectivity() {
    return Future.value([
      ConnectivityResult.mobile,
    ]);
  }
}
