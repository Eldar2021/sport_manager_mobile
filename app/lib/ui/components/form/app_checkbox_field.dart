import 'package:flutter/material.dart';

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

    return FormField(
      initialValue: initialValue,
      autovalidateMode: AutovalidateMode.disabled,
      validator: validator,
      builder: (field) {
        return CheckboxListTile(
          value: field.value,
          isThreeLine: field.hasError,
          activeColor: colorScheme.primary,
          checkColor: colorScheme.onPrimary,
          contentPadding: const EdgeInsets.symmetric(vertical: 4),
          controlAffinity: ListTileControlAffinity.leading,
          checkboxScaleFactor: 1.3,
          side: BorderSide(color: colorScheme.outline),
          isError: field.hasError,
          checkboxShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
          title: Text(label, style: textTheme.bodyMedium),
          onChanged: (v) => field.didChange(v),
          subtitle: field.hasError
              ? Text(
                  field.errorText!,
                  style: textTheme.bodySmall?.copyWith(color: colorScheme.error),
                )
              : null,
        );
      },
    );
  }
}
