import 'package:flutter/material.dart';

/// Selectable category filter chip.
///
/// Wraps [ChoiceChip] so it inherits theme styling, ink splash and semantics.
class AppCategoryChip extends StatelessWidget {
  const AppCategoryChip({
    required this.label,
    this.isSelected = false,
    this.onSelected,
    super.key,
  });

  final String label;
  final bool isSelected;
  final ValueChanged<bool>? onSelected;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: onSelected,
      side: isSelected ? BorderSide.none : null,
    );
  }
}
