// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get homeWelcomeBack => 'Welcome back';

  @override
  String get settingsAppearance => 'Appearance';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsThemeLight => 'Light';

  @override
  String get settingsThemeDark => 'Dark';

  @override
  String get settingsThemeSystem => 'System';

  @override
  String get authTagline => 'Digital hall management';

  @override
  String get authSignIn => 'Sign In';

  @override
  String get authSignUp => 'Sign Up';

  @override
  String get authSignInSubtitle => 'Enter your credentials';

  @override
  String get authUsernameOrEmail => 'Username or email';

  @override
  String get authPassword => 'Password';

  @override
  String get authForgotPassword => 'Forgot password?';

  @override
  String get authNoAccount => 'No account?';

  @override
  String get authChooseRole => 'Who are you?';

  @override
  String get authChooseRoleSubtitle => 'This will determine available features';

  @override
  String get authOwnerTitle => 'Hall owner';

  @override
  String get authOwnerSubtitle => 'I manage one or more halls';

  @override
  String get authManagerTitle => 'Hall manager';

  @override
  String get authManagerSubtitle => 'I work shifts, I need an invite code';

  @override
  String get authRegisterOwnerTitle => 'Owner registration';

  @override
  String get authRegisterManagerTitle => 'Manager registration';

  @override
  String get authOwnerBadge => 'Owner';

  @override
  String get authManagerBadge => 'Manager';

  @override
  String get authNameLabel => 'Name';

  @override
  String get authPhoneLabel => 'Phone';

  @override
  String get authEmailLabel => 'Email';

  @override
  String get authInviteCodeLabel => 'Invite code';

  @override
  String get authUsernameLabel => 'Username';

  @override
  String get authConfirmPasswordLabel => 'Confirm password';

  @override
  String get authVenueNameLabel => 'Venue name';

  @override
  String get authVenueNumberLabel => 'Venue number';

  @override
  String get authAgreeTerms => 'I agree to the terms';

  @override
  String get authAgreeTermsError => 'You must agree to the terms';

  @override
  String get authCreateAccount => 'Create account';

  @override
  String get authInviteCodeHint => 'Get the invite code from the hall owner';

  @override
  String get authFieldRequired => 'Field must be filled';

  @override
  String get authPasswordMinLength => 'Password must be at least 8 characters';

  @override
  String get authPasswordsDoNotMatch => 'Passwords do not match';

  @override
  String get authInvalidEmail => 'Enter a valid email address';

  @override
  String get authInvalidPhone => 'Enter a valid phone number';

  @override
  String get authForgotPasswordTitle => 'Password Recovery';

  @override
  String get authForgotPasswordBanner => 'Enter your login or email — we\'ll send a link to reset your password.';

  @override
  String get authForgotPasswordLoginEmailPlaceholder => 'e.g., azamat@mail.kg';

  @override
  String get authForgotPasswordNoLink => 'Link not arriving?';

  @override
  String get authForgotPasswordContactUs => 'Contact us — WhatsApp, Telegram, email, call';

  @override
  String get authForgotPasswordSendLink => 'Send link';

  @override
  String get authContactSupportTitle => 'Contact Support';

  @override
  String get authContactSupportSubtitle => 'Write or call — we\'ll help restore access.';

  @override
  String get authContactCallLabel => 'Call';
}
