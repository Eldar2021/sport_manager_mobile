import 'package:flutter/material.dart';

class LanguageTile extends StatelessWidget {
  const LanguageTile({
    required this.name,
    required this.isSelected,
    required this.onTap,
    super.key,
  });

  final String name;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
      title: Text(
        name,
        style: theme.textTheme.bodyLarge?.copyWith(
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
        ),
      ),
      trailing: isSelected ? const Icon(Icons.check_circle_rounded) : null,
    );
  }
}
