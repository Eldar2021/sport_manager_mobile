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

  static const _presets = [150, 200, 250, 300, 350, 400];

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
              selectedColor: context.colorScheme.primary,
              backgroundColor: Colors.transparent,
              side: BorderSide(
                color: selected == rate ? context.colorScheme.primary : context.colorScheme.onSurfaceVariant,
              ),
              labelStyle: AppTypography.body.copyWith(
                color: selected == rate ? context.colorScheme.onPrimary : context.colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
              onSelected: (_) => onChanged(rate),
            ),
          )
          .toList(),
    );
  }
}
