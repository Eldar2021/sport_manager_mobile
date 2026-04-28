import 'package:facility/facility.dart';
import 'package:flutter/material.dart';
import 'package:sport_manager_mobile/l10n/l10n.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

class TarifTypeSelector extends StatelessWidget {
  const TarifTypeSelector({
    required this.selected,
    required this.onChanged,
    super.key,
  });

  final TarifType selected;
  final ValueChanged<TarifType> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: TarifType.values.map((type) {
        final isSelected = selected == type;
        return Expanded(
          child: ChoiceChip(
            label: Center(child: Text(type._label(context))),
            selected: isSelected,
            showCheckmark: false,
            selectedColor: context.colors.primary,
            backgroundColor: AppColors.transparent,
            side: BorderSide.none,
            labelStyle: context.textTheme.bodyMedium?.copyWith(
              color: isSelected ? context.colors.onPrimary : context.colors.onSurface,
              fontWeight: FontWeight.w600,
            ),
            onSelected: (_) => onChanged(type),
          ),
        );
      }).toList(),
    );
  }
}

extension on TarifType {
  String _label(BuildContext context) => switch (this) {
    TarifType.minute => context.l10n.tarifTypeMinute,
    TarifType.hour => context.l10n.tarifTypeHour,
    TarifType.day => context.l10n.tarifTypeDay,
  };
}
