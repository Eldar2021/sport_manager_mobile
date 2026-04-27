import 'package:flutter/material.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

class AppPasswordField extends StatefulWidget {
  const AppPasswordField({
    required this.label,
    required this.controller,
    super.key,
    this.textInputAction,
    this.onSubmitted,
    this.validator,
    this.onChanged,
    this.hintText,
    this.initiallyObscured = true,
  });

  final String label;
  final TextEditingController controller;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onSubmitted;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;
  final String? hintText;
  final bool initiallyObscured;

  @override
  State<AppPasswordField> createState() => _AppPasswordFieldState();
}

class _AppPasswordFieldState extends State<AppPasswordField> {
  late bool _obscure = widget.initiallyObscured;

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      label: widget.label,
      controller: widget.controller,
      obscureText: _obscure,
      textInputAction: widget.textInputAction,
      onSubmitted: widget.onSubmitted,
      validator: widget.validator,
      onChanged: widget.onChanged,
      hintText: widget.hintText,
      suffixIcon: IconButton(
        icon: Icon(
          _obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined,
        ),
        onPressed: () => setState(() => _obscure = !_obscure),
      ),
    );
  }
}
