import 'package:flutter/material.dart';
import 'package:sport_manager_mobile/ui/theme/theme.dart';

class AppCheckboxField extends StatelessWidget {
  const AppCheckboxField({
    required this.label,
    super.key,
    this.validator,
    this.initialValue = false,
  });

  final String label;
  final FormFieldValidator<bool>? validator;
  final bool initialValue;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return FormField<bool>(
      initialValue: initialValue,
      autovalidateMode: AutovalidateMode.disabled,
      validator: validator,
      builder: (field) {
        final checked = field.value ?? false;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () => field.didChange(!checked),
              behavior: HitTestBehavior.opaque,
              child: Row(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      color: checked ? colorScheme.primary : Colors.transparent,
                      borderRadius: const BorderRadius.all(Radius.circular(6)),
                      border: Border.all(
                        color: checked ? colorScheme.primary : colorScheme.outline,
                        width: 1.5,
                      ),
                    ),
                    child: checked ? Icon(Icons.check_rounded, color: colorScheme.surfaceContainer, size: 16) : null,
                  ),
                  const SizedBox(width: AppSpacing.x3),
                  Text(label, style: textTheme.bodyMedium),
                ],
              ),
            ),
            if (field.hasError) ...[
              const SizedBox(height: 4),
              Text(
                field.errorText!,
                style: textTheme.bodySmall?.copyWith(color: AppColors.dangerRed),
              ),
            ],
          ],
        );
      },
    );
  }
}
