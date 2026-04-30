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

  @override
  String get navHome => 'Home';

  @override
  String get navReport => 'Reports';

  @override
  String get navProfile => 'Profile';

  @override
  String get homeCreateVenue => 'Create venue';

  @override
  String get homeNoVenuesTitle => 'You have no venues yet';

  @override
  String get homeNoVenuesSubtitle => 'Create your first venue to start adding tables and accepting sessions.';

  @override
  String get homeSelectVenue => 'Select venue';

  @override
  String get homeNewVenue => 'New venue';

  @override
  String get homeAddTable => 'Add table';

  @override
  String get homeTablesEmpty => 'No tables yet';

  @override
  String get homeTablesEmptySub => 'Add the first table so managers can start sessions.';

  @override
  String get homeTableOccupied => 'OCCUPIED';

  @override
  String get homeTablePaused => 'PAUSED';

  @override
  String get homeTableFree => 'FREE';

  @override
  String get homeTableJustFreed => '✓ Done';

  @override
  String get createTableTitle => 'New table';

  @override
  String get createTableNumberLabel => 'Table number';

  @override
  String get createTableNumberHint => '1';

  @override
  String get createTableNameLabel => 'Table name';

  @override
  String get createTableNameHint => 'Table 1';

  @override
  String get createTableDescLabel => 'Description (tag)';

  @override
  String get createTableDescHint => 'VIP room, window seat, snooker...';

  @override
  String get createTableDescPlaceholder => 'Description';

  @override
  String get createTableRateLabel => 'Rate';

  @override
  String createTableRateSuffix(Object currency, Object time_unit) {
    return '$currency/$time_unit';
  }

  @override
  String get createTableButton => 'Create table';

  @override
  String get editTableTitle => 'Edit table';

  @override
  String get updateTableButton => 'Update table';

  @override
  String get deleteTableButton => 'Delete';

  @override
  String get createVenueTitle => 'Create your venue';

  @override
  String get createVenueSubtitle => 'Give your venue a name. Tables can be added later from the home page.';

  @override
  String get createVenueNameLabel => 'Venue name';

  @override
  String get createVenueNameHint => 'Central branch';

  @override
  String get createVenueNumberLabel => 'Short code / number (optional)';

  @override
  String get createVenueNumberHint => 'No. 1 or CF';

  @override
  String get createVenueInfoBanner =>
      'After creating the venue you will be able to add tables one by one with their own rate.';

  @override
  String get createVenueButton => 'Create venue →';

  @override
  String get editVenueTitle => 'Edit venue';

  @override
  String get updateVenueButton => 'Update';

  @override
  String get deleteVenueButton => 'Delete';

  @override
  String get deleteVenueSubtitle => 'All tables and session history will be preserved, but the venue will be removed.';

  @override
  String get cancel => 'Cancel';

  @override
  String get deleteTableSubtitle =>
      'Session history will be preserved, but the table will disappear from the home page.';

  @override
  String get generalRetry => 'Retry';

  @override
  String get createTableTarifTypeLabel => 'Tariff type';

  @override
  String get tarifTypeMinute => 'Minute';

  @override
  String get tarifTypeHour => 'Hour';

  @override
  String get tarifTypeDay => 'Day';

  @override
  String get createTableCurrencyLabel => 'Currency';

  @override
  String get currencyKgs => 'Som';

  @override
  String get currencyUsd => 'Dollar';

  @override
  String get currencyRub => 'Ruble';

  @override
  String get currencyKzt => 'Tenge';

  @override
  String get currencyTry => 'Lira';

  @override
  String venueTablesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tables',
      one: '1 table',
      zero: 'no tables',
    );
    return '$_temp0';
  }

  @override
  String homeTableTitle(int number) {
    return 'Table $number';
  }

  @override
  String homeTablesSection(int count) {
    return 'TABLES · $count';
  }

  @override
  String get profileSectionManagement => 'Management';

  @override
  String get profileManageVenuesTitle => 'Manage venues';

  @override
  String profileManageVenuesSubtitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count venues',
      one: '1 venue',
      zero: 'No venues',
    );
    return '$_temp0';
  }

  @override
  String get profileManagersTitle => 'Managers';

  @override
  String profileManagersSubtitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count managers',
      one: '1 manager',
      zero: 'No managers',
    );
    return '$_temp0';
  }

  @override
  String get profileSectionAccount => 'Account';

  @override
  String get profileSubscriptionTitle => 'Subscription';

  @override
  String profileSubscriptionActiveUntil(String date) {
    return 'Active · until $date';
  }

  @override
  String get profileChangePasswordTitle => 'Change password';

  @override
  String get profileLogout => 'Log out';

  @override
  String get profileDeleteAccount => 'Delete account';

  @override
  String get profileErrorTitle => 'Couldn\'t load profile';

  @override
  String get profileErrorSubtitle => 'Check your connection and try again.';

  @override
  String get menuEdit => 'Edit';

  @override
  String get menuDelete => 'Delete';

  @override
  String get venueMetricTablesLabel => 'TABLES';

  @override
  String get venueDetailTablesHeader => 'HALL TABLES';

  @override
  String venueTablesCountSuffix(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pcs',
      one: '1 pc',
      zero: '0 pcs',
    );
    return '$_temp0';
  }
}
