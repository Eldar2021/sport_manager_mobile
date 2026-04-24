import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:sport_manager_mobile/app/app.dart';
import 'package:sport_manager_mobile/core/core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await diInit(GetIt.instance, [
    const CoreModule(),
    const ErrorModule(),
    const NetworkModule(),
    const AuthModule(),
  ]);

  runApp(const MyAppWrapper());
}
