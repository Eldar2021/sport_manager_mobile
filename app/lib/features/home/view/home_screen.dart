import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sport_manager_mobile/app/app.dart';
import 'package:sport_manager_mobile/l10n/l10n.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.l10n.homeWelcomeBack,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        actions: [
          ElevatedButton.icon(
            icon: const Icon(Icons.settings_outlined),
            label: Text(context.l10n.settingsThemeSystem),
            onPressed: () => context.push(AppRoutes.settings),
          ),
          const SizedBox(width: 24),
        ],
      ),
    );
  }
}
