import 'dart:async';
import 'package:core/core.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:sport_manager_mobile/app/app.dart';
import 'package:sport_manager_mobile/core/core.dart';
import 'package:sport_manager_mobile/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await diInit(GetIt.instance, [
    const CoreModule(),
    const ErrorModule(),
    const NetworkModule(),
    const AuthModule(),
    const FacilityModule(),
    const ManagersModule(),
    const SubscriptionModule(),
    const ReportsModule(),
  ]);

  runApp(const MyAppWrapper());

  unawaited(GetIt.I<RemoteConfigRepository>().fetch());
}
