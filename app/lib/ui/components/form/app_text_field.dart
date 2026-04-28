import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

/// Text input with the field label rendered as a sibling [Text] above the
/// [TextFormField] (instead of `InputDecoration.labelText`'s floating label).
/// This is intentional — the design system wants a static, always-visible
/// label. Don't migrate to a floating label without a design discussion.
class AppTextField extends StatelessWidget {
  const AppTextField({
    required this.label,
    super.key,
    this.controller,
    this.focusNode,
    this.obscureText = false,
    this.autofocus = false,
    this.keyboardType,
    this.textInputAction,
    this.suffixIcon,
    this.prefixIcon,
    this.hintText,
    this.helperText,
    this.onSubmitted,
    this.validator,
    this.inputFormatters,
    this.onChanged,
    this.enabled = true,
    this.maxLength,
    this.maxLines = 1,
    this.counterText = '',
  });

  final String label;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final bool obscureText;
  final bool autofocus;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final String? hintText;
  final String? helperText;
  final ValueChanged<String>? onSubmitted;
  final FormFieldValidator<String>? validator;
  final List<TextInputFormatter>? inputFormatters;
  final ValueChanged<String>? onChanged;
  final bool enabled;
  final int? maxLength;
  final int? maxLines;
  final String? counterText;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: context.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: AppSpacing.x2),
        TextFormField(
          controller: controller,
          focusNode: focusNode,
          obscureText: obscureText,
          autofocus: autofocus,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          inputFormatters: inputFormatters,
          onChanged: onChanged,
          onFieldSubmitted: onSubmitted,
          validator: validator,
          enabled: enabled,
          maxLength: maxLength,
          maxLines: obscureText ? 1 : maxLines,
          style: context.textTheme.bodyMedium,
          decoration: InputDecoration(
            counterText: counterText,
            hintText: hintText,
            helperText: helperText,
            suffixIcon: suffixIcon,
            prefixIcon: prefixIcon,
          ),
        ),
      ],
    );
  }
}
