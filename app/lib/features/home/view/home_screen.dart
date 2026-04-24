import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'home',
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
      body: const Center(child: Text('home')),
    );
  }
}
