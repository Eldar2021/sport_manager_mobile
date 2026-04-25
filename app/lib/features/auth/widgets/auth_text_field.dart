import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

class AuthTextField extends StatefulWidget {
  const AuthTextField({
    required this.label,
    super.key,
    this.controller,
    this.obscureText = false,
    this.autofocus = false,
    this.keyboardType,
    this.textInputAction,
    this.errorText,
    this.suffixIcon,
    this.hintText,
    this.onSubmitted,
    this.validator,
    this.inputFormatters,
    this.onChanged,
  });

  final String label;
  final TextEditingController? controller;
  final bool obscureText;
  final bool autofocus;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final String? errorText;
  final Widget? suffixIcon;
  final String? hintText;
  final VoidCallback? onSubmitted;
  final FormFieldValidator<String>? validator;
  final List<TextInputFormatter>? inputFormatters;
  final void Function(String)? onChanged;

  @override
  State<AuthTextField> createState() => _AuthTextFieldState();
}

class _AuthTextFieldState extends State<AuthTextField> {
  final _focus = FocusNode();
  bool _focused = false;
  @override
  void initState() {
    super.initState();
    _focus.addListener(_onFocusChange);
  }

  void _onFocusChange() => setState(() => _focused = _focus.hasFocus);

  @override
  void dispose() {
    _focus
      ..removeListener(_onFocusChange)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      autovalidateMode: AutovalidateMode.disabled,
      validator: widget.validator != null ? (_) => widget.validator!(widget.controller?.text ?? '') : null,
      builder: (field) {
        final errorText = widget.validator != null ? field.errorText : widget.errorText;
        final hasError = errorText != null;
        final borderColor = hasError
            ? AppColors.dangerRed
            : _focused
            ? AppColors.brandAmber
            : AppColors.ink300;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 6),
            AnimatedContainer(
              duration: const Duration(milliseconds: 120),
              height: 48,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainer,
                borderRadius: AppRadius.inputBorderRadius,
                border: Border.all(color: borderColor, width: 1.5),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      focusNode: _focus,
                      controller: widget.controller,
                      obscureText: widget.obscureText,
                      keyboardType: widget.keyboardType,
                      textInputAction: widget.textInputAction,
                      autofocus: widget.autofocus,
                      inputFormatters: widget.inputFormatters,
                      onSubmitted: widget.onSubmitted != null ? (_) => widget.onSubmitted!() : null,
                      onChanged: widget.onChanged,
                      style: Theme.of(context).textTheme.bodyMedium,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14),
                        hintText: widget.hintText,
                        hintStyle: Theme.of(context).textTheme.bodyMedium,
                        isDense: true,
                      ),
                    ),
                  ),
                  if (widget.suffixIcon != null)
                    Padding(
                      padding: const EdgeInsets.only(right: 4),
                      child: widget.suffixIcon,
                    ),
                ],
              ),
            ),
            if (hasError) ...[
              const SizedBox(height: 4),
              Text(
                errorText,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.dangerRed),
              ),
            ],
          ],
        );
      },
    );
  }
}
