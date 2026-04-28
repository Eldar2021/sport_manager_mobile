import 'package:facility/facility.dart';
import 'package:flutter/material.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

class CurrencySelector extends StatelessWidget {
  const CurrencySelector({
    required this.selected,
    required this.onChanged,
    super.key,
  });

  final Currency selected;
  final ValueChanged<Currency> onChanged;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.x2,
      children: Currency.values.map((currency) {
        final isSelected = selected == currency;
        return ChoiceChip(
          label: Text(currency._code),
          selected: isSelected,
          showCheckmark: false,
          selectedColor: context.colors.primary,
          backgroundColor: AppColors.transparent,
          side: BorderSide.none,
          labelStyle: context.textTheme.bodyMedium?.copyWith(
            color: isSelected ? context.colors.onPrimary : context.colors.onSurface,
            fontWeight: FontWeight.w600,
          ),
          onSelected: (_) => onChanged(currency),
        );
      }).toList(),
    );
  }
}

extension on Currency {
  String get _code => switch (this) {
    Currency.kgs => 'KGS',
    Currency.usd => 'USD',
    Currency.rub => 'RUB',
    Currency.kzt => 'KZT',
    Currency.tryLira => 'TRY',
  };
}
