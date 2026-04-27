import 'package:flutter/material.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

class AppSubmitButton extends StatelessWidget {
  const AppSubmitButton({
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.leadingIcon,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Widget? leadingIcon;

  static const double _spinnerSize = 22;
  static const double _spinnerStrokeWidth = 2.5;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: isLoading ? null : onPressed,
      style: FilledButton.styleFrom(
        minimumSize: const Size.fromHeight(AppSpacing.x14),
      ),
      child: isLoading
          ? SizedBox(
              width: _spinnerSize,
              height: _spinnerSize,
              child: CircularProgressIndicator(
                strokeWidth: _spinnerStrokeWidth,
                color: context.colors.onPrimary,
              ),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (leadingIcon != null) ...[
                  leadingIcon!,
                  const SizedBox(width: AppSpacing.x2),
                ],
                Text(label),
              ],
            ),
    );
  }
}
