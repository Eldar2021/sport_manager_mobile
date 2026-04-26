import 'package:flutter/material.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

class AppSubmitButton extends StatelessWidget {
  const AppSubmitButton({
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: isLoading ? null : onPressed,
      style: FilledButton.styleFrom(
        minimumSize: const Size.fromHeight(56),
      ),
      child: isLoading
          ? SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: context.colors.onPrimary,
              ),
            )
          : Text(label),
    );
  }
}
