import 'package:flutter/material.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

/// Slightly larger than the Material default to match the design system.
const double _checkboxScaleFactor = 1.3;

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
    final colors = context.colors;

    return FormField<bool>(
      initialValue: initialValue,
      autovalidateMode: AutovalidateMode.disabled,
      validator: validator,
      builder: (field) {
        return CheckboxListTile(
          value: field.value,
          // Forces the tile to reserve room for the error subtitle without
          // jumping the layout when validation fails.
          isThreeLine: field.hasError,
          activeColor: colors.primary,
          checkColor: colors.onPrimary,
          contentPadding: const EdgeInsets.symmetric(vertical: AppSpacing.x1),
          controlAffinity: ListTileControlAffinity.leading,
          checkboxScaleFactor: _checkboxScaleFactor,
          side: BorderSide(color: colors.outline),
          isError: field.hasError,
          checkboxShape: const RoundedRectangleBorder(
            borderRadius: AppRadius.checkboxBorderRadius,
          ),
          title: Text(label, style: context.textTheme.bodyMedium),
          onChanged: field.didChange,
          subtitle: field.hasError
              ? Text(
                  field.errorText ?? '',
                  style: context.appTextStyles.error.bodySmall,
                )
              : null,
        );
      },
    );
  }
}
