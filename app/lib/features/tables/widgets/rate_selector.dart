import 'package:flutter/material.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

class RateSelector extends StatelessWidget {
  const RateSelector({
    required this.selected,
    required this.onChanged,
    super.key,
  });

  final int selected;
  final ValueChanged<int> onChanged;

  static const _presets = [200, 250, 300, 350, 400];

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.x2,
      runSpacing: AppSpacing.x2,
      children: _presets
          .map(
            (rate) => ChoiceChip(
              label: Text('$rate'),
              selected: selected == rate,
              showCheckmark: false,
              selectedColor: context.colors.primary,
              backgroundColor: AppColors.transparent,
              side: BorderSide.none,
              labelStyle: context.textTheme.bodyMedium?.copyWith(
                color: selected == rate ? context.colors.onPrimary : context.colors.onSurface,
                fontWeight: FontWeight.w600,
              ),
              onSelected: (_) => onChanged(rate),
            ),
          )
          .toList(),
    );
  }
}
