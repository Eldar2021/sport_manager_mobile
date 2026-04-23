import 'package:flutter/material.dart';

class SettingsSectionTitle extends StatelessWidget {
  const SettingsSectionTitle(this.title, {super.key});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title.toUpperCase(),
      style: Theme.of(context).textTheme.labelSmall?.copyWith(
        letterSpacing: 1.2,
      ),
    );
  }
}
