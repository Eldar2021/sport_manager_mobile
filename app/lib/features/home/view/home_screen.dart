import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sport_manager_mobile/app/app.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'test',
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
      body: Column(
        children: [
          ElevatedButton.icon(
            icon: const Icon(Icons.settings_outlined),
            label: const Text('test'),
            onPressed: () => context.push(AppRoutes.settings),
          ),
        ],
      ),
    );
  }
}
