import 'package:auth/auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:sport_manager_mobile/app/app.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('home', style: Theme.of(context).textTheme.titleMedium),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            onPressed: () async {
              await GetIt.I<AuthRepository>().logout();
              if (context.mounted) context.go(AppRoutes.welcome);
            },
          ),
        ],
      ),
      body: const Center(child: Text('home')),
    );
  }
}
