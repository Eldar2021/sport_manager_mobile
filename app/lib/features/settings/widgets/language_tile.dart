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

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,

        decoration: BoxDecoration(
          border: Border.all(
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                name,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
            ),
            AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              opacity: isSelected ? 1 : 0,
              child: const Icon(Icons.check_circle_rounded),
            ),
          ],
        ),
      ),
    );
  }
}
