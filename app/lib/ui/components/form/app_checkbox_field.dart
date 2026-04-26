import 'package:flutter/material.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

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

    return FormField(
      initialValue: initialValue,
      autovalidateMode: AutovalidateMode.disabled,
      validator: validator,
      builder: (field) {
        return CheckboxListTile(
          value: field.value,
          isThreeLine: field.hasError,
          activeColor: colors.primary,
          checkColor: colors.onPrimary,
          contentPadding: const EdgeInsets.symmetric(vertical: AppSpacing.x1),
          controlAffinity: ListTileControlAffinity.leading,
          checkboxScaleFactor: 1.3,
          side: BorderSide(color: colors.outline),
          isError: field.hasError,
          checkboxShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
          title: Text(label, style: context.textTheme.bodyMedium),
          onChanged: (v) => field.didChange(v),
          subtitle: field.hasError
              ? Text(
                  field.errorText!,
                  style: context.appTextStyles.error.bodySmall,
                )
              : null,
        );
      },
    );
  }
}
