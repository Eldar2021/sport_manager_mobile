import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sport_manager_mobile/app/app.dart';
import 'package:sport_manager_mobile/features/tables/tables.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push(
            AppRoutes.tableForm,
            extra: const TableFormExtra(
              venueId: 'venue_id',
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: const Column(),
    );
  }
}
