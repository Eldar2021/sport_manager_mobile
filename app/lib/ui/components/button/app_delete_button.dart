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
    return TextButton.icon(
      onPressed: isLoading ? null : onTap,
      icon: isLoading
          ? const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator.adaptive(strokeWidth: 2),
            )
          : const Icon(Icons.delete_outline_rounded),
      label: isLoading ? const SizedBox.shrink() : Text(label),
      style: TextButton.styleFrom(
        foregroundColor: context.colors.error,
        backgroundColor: context.colors.errorContainer,
        iconSize: 16,
        shape: const RoundedRectangleBorder(
          borderRadius: AppRadius.buttonBorderRadius,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.x3,
          vertical: AppSpacing.x2,
        ),
        textStyle: context.textTheme.bodySmall?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
