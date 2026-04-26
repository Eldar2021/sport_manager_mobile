import 'package:flutter/material.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

class AppDeleteButton extends StatelessWidget {
  const AppDeleteButton({
    required this.label,
    required this.onTap,
    this.isLoading = false,
    super.key,
  });

  final String label;
  final VoidCallback onTap;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: DecoratedBox(
        decoration: const BoxDecoration(
          color: AppColors.dangerLight,
          borderRadius: AppRadius.chipBorderRadius,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x3, vertical: AppSpacing.x2),
          child: isLoading
              ? const AppActivityIndicator(width: 16, height: 16, color: AppColors.dangerRed)
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.delete_outline_rounded, color: AppColors.dangerRed, size: 16),
                    const SizedBox(width: AppSpacing.x1),
                    Text(
                      label,
                      style: AppTypography.caption.copyWith(
                        color: AppColors.dangerRed,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
