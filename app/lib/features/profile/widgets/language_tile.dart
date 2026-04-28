import 'package:flutter/material.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

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
    return ListTile(
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
      title: Text(
        name,
        style: context.textTheme.bodyLarge?.copyWith(
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
        ),
      ),
      trailing: isSelected ? const Icon(Icons.check_circle_rounded) : null,
    );
  }
}
