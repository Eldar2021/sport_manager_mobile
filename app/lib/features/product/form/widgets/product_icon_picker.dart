import 'package:flutter/material.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

// 3 rows × chip height + 2 gaps
const double _kPickerHeight = 40.0 * 3 + AppSpacing.x2 * 2;

class ProductIconPicker extends StatelessWidget {
  const ProductIconPicker({
    required this.emojis,
    required this.selected,
    required this.onChanged,
    super.key,
  });

  final List<String> emojis;
  final String? selected;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    if (emojis.isEmpty) return const SizedBox(height: _kPickerHeight);
    return SizedBox(
      height: _kPickerHeight,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Wrap(
          direction: Axis.vertical,
          spacing: AppSpacing.x2,
          runSpacing: AppSpacing.x2,
          children: emojis
              .map((emoji) {
                final isSelected = emoji == selected;
                return ChoiceChip(
                  label: Text(emoji, style: const TextStyle(fontSize: 22)),
                  selected: isSelected,
                  showCheckmark: false,
                  labelPadding: EdgeInsets.zero,
                  padding: const EdgeInsets.all(AppSpacing.x2),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  onSelected: (_) => onChanged(isSelected ? null : emoji),
                );
              })
              .toList(growable: false),
        ),
      ),
    );
  }
}
