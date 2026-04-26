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
      children: _presets.map((rate) => _RateChip(
        rate: rate,
        isSelected: selected == rate,
        onTap: () => onChanged(rate),
      )).toList(),
    );
  }
}

class _RateChip extends StatelessWidget {
  const _RateChip({
    required this.rate,
    required this.isSelected,
    required this.onTap,
  });

  final int rate;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.x4,
          vertical: AppSpacing.x2,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.brandAmber : Colors.transparent,
          borderRadius: AppRadius.chipBorderRadius,
          border: Border.all(
            color: isSelected ? AppColors.brandAmber : AppColors.ink300,
          ),
        ),
        child: Text(
          '$rate',
          style: AppTypography.body.copyWith(
            color: isSelected ? AppColors.white : AppColors.ink700,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
