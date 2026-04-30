import 'package:flutter/material.dart';
import 'package:sport_manager_mobile/l10n/l10n.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

class TableDetailStartFab extends StatelessWidget {
  const TableDetailStartFab({
    required this.isLoading,
    required this.onPressed,
    super.key,
  });

  final bool isLoading;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x4),
      child: FilledButton(
        onPressed: isLoading ? null : onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: context.appColors.success,
          foregroundColor: context.appColors.onSuccess,
          minimumSize: const Size(double.infinity, AppSpacing.x16),
          shape: const RoundedRectangleBorder(
            borderRadius: AppRadius.buttonBorderRadius,
          ),
        ),
        child: isLoading ? const AppActivityIndicator() : Text(context.l10n.tableDetailStart),
      ),
    );
  }
}
