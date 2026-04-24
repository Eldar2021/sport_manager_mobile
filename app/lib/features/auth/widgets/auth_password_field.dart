import 'package:flutter/material.dart';
import 'package:sport_manager_mobile/features/auth/widgets/auth_text_field.dart';

class AuthPasswordField extends StatefulWidget {
  const AuthPasswordField({
    required this.label,
    required this.controller,
    super.key,
    this.textInputAction,
    this.onSubmitted,
    this.validator,
  });

  final String label;
  final TextEditingController controller;
  final TextInputAction? textInputAction;
  final VoidCallback? onSubmitted;
  final FormFieldValidator<String>? validator;

  @override
  State<AuthPasswordField> createState() => _AuthPasswordFieldState();
}

class _AuthPasswordFieldState extends State<AuthPasswordField> {
  bool _show = false;

  @override
  Widget build(BuildContext context) {
    return AuthTextField(
      label: widget.label,
      controller: widget.controller,
      obscureText: !_show,
      textInputAction: widget.textInputAction,
      onSubmitted: widget.onSubmitted,
      validator: widget.validator,
      suffixIcon: IconButton(
        icon: Icon(_show ? Icons.visibility_off_outlined : Icons.visibility_outlined),
        onPressed: () => setState(() => _show = !_show),
      ),
    );
  }
}
