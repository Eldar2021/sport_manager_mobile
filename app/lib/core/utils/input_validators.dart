import 'package:flutter/widgets.dart';
import 'package:sport_manager_mobile/l10n/l10n.dart';

abstract final class InputValidators {
  const InputValidators._();

  static final _emailRegex = RegExp(r'^[\w.+-]+@[\w-]+\.[a-zA-Z]{2,}$');

  static String? emptyValidator(String? val, BuildContext ctx) {
    return val?.trim().isEmpty ?? true ? ctx.l10n.authFieldRequired : null;
  }

  static bool isValidEmail(String email) => _emailRegex.hasMatch(email.trim());

  static String? emailValidator(String? val, BuildContext ctx) {
    if (val == null || val.trim().isEmpty) return ctx.l10n.authFieldRequired;
    if (!_emailRegex.hasMatch(val.trim())) return ctx.l10n.authInvalidEmail;
    return null;
  }

  static String? phoneValidator(String? val, BuildContext ctx, {required int expectedLength}) {
    if (val == null || val.trim().isEmpty) return ctx.l10n.authFieldRequired;
    final digits = val.replaceAll(RegExp(r'\D'), '');
    if (digits.length < expectedLength) return ctx.l10n.authInvalidPhone;
    return null;
  }

  static String? passwordValidator(String? val, BuildContext ctx) {
    if (val == null || val.trim().isEmpty) return ctx.l10n.authFieldRequired;
    if (val.length < 8) return ctx.l10n.authPasswordMinLength;
    return null;
  }

  static String? passwordConfirmValidator(String? val, String? password, BuildContext ctx) {
    if (val == null || val.trim().isEmpty) return ctx.l10n.authFieldRequired;
    if (val != password) return ctx.l10n.authPasswordsDoNotMatch;
    return null;
  }
}
