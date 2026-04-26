import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:sport_manager_mobile/features/auth/auth.dart';

class GoRouterAuthListenable extends ChangeNotifier {
  GoRouterAuthListenable(Stream<AuthState> stream) {
    _subscription = stream.listen((_) => notifyListeners());
  }

  late final StreamSubscription<AuthState> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
