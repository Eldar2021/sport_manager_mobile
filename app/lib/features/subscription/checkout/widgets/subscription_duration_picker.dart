import 'package:flutter/material.dart';
import 'package:sport_manager_mobile/l10n/l10n.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

class SubscriptionDurationPicker extends StatelessWidget {
  const SubscriptionDurationPicker({
    required this.value,
    required this.minMonths,
    required this.maxMonths,
    required this.onChanged,
    super.key,
  });

  final int value;
  final int minMonths;
  final int maxMonths;
  final ValueChanged<int> onChanged;

  static const _presets = <int>[1, 3, 6, 12];

  @override
  Widget build(BuildContext context) {
    final presets = _presets.where((m) => m >= minMonths && m <= maxMonths).toList(growable: false);
    return Wrap(
      spacing: AppSpacing.x2,
      runSpacing: AppSpacing.x2,
      children: [
        for (final months in presets)
          ChoiceChip(
            label: Text(
              context.l10n.subscriptionCheckoutMonthsLabel(months),
            ),
            selected: months == value,
            onSelected: (_) => onChanged(months),
          ),
      ],
    );
  }
}
