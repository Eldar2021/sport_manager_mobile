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
    return SizedBox(
      width: double.infinity,
      child: SegmentedButton<TarifType>(
        style: SegmentedButton.styleFrom(
          selectedBackgroundColor: context.colors.primary,
          selectedForegroundColor: context.colors.onPrimary,
          foregroundColor: context.colors.onSurface,
          textStyle: context.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        segments: [
          ButtonSegment(
            value: TarifType.minute,
            label: Text(context.l10n.tarifTypeMinute),
          ),
          ButtonSegment(
            value: TarifType.hour,
            label: Text(context.l10n.tarifTypeHour),
          ),
          ButtonSegment(
            value: TarifType.day,
            label: Text(context.l10n.tarifTypeDay),
          ),
        ],
        selected: {selected},
        onSelectionChanged: (selection) => onChanged(selection.first),
        showSelectedIcon: false,
      ),
    );
  }
}
