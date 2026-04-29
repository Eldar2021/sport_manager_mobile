import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ky.dart';
import 'app_localizations_ru.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('en'), Locale('ky'), Locale('ru')];

  /// No description provided for @homeWelcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get homeWelcomeBack;

  /// No description provided for @settingsAppearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get settingsAppearance;

  /// No description provided for @settingsLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguage;

  /// No description provided for @settingsThemeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get settingsThemeLight;

  /// No description provided for @settingsThemeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get settingsThemeDark;

  /// No description provided for @settingsThemeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get settingsThemeSystem;

  /// No description provided for @authTagline.
  ///
  /// In en, this message translates to:
  /// **'Digital hall management'**
  String get authTagline;

  /// No description provided for @authSignIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get authSignIn;

  /// No description provided for @authSignUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get authSignUp;

  /// No description provided for @authSignInSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your credentials'**
  String get authSignInSubtitle;

  /// No description provided for @authUsernameOrEmail.
  ///
  /// In en, this message translates to:
  /// **'Username or email'**
  String get authUsernameOrEmail;

  /// No description provided for @authPassword.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get authPassword;

  /// No description provided for @authForgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get authForgotPassword;

  /// No description provided for @authNoAccount.
  ///
  /// In en, this message translates to:
  /// **'No account?'**
  String get authNoAccount;

  /// No description provided for @authChooseRole.
  ///
  /// In en, this message translates to:
  /// **'Who are you?'**
  String get authChooseRole;

  /// No description provided for @authChooseRoleSubtitle.
  ///
  /// In en, this message translates to:
  /// **'This will determine available features'**
  String get authChooseRoleSubtitle;

  /// No description provided for @authOwnerTitle.
  ///
  /// In en, this message translates to:
  /// **'Hall owner'**
  String get authOwnerTitle;

  /// No description provided for @authOwnerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'I manage one or more halls'**
  String get authOwnerSubtitle;

  /// No description provided for @authManagerTitle.
  ///
  /// In en, this message translates to:
  /// **'Hall manager'**
  String get authManagerTitle;

  /// No description provided for @authManagerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'I work shifts, I need an invite code'**
  String get authManagerSubtitle;

  /// No description provided for @authRegisterOwnerTitle.
  ///
  /// In en, this message translates to:
  /// **'Owner registration'**
  String get authRegisterOwnerTitle;

  /// No description provided for @authRegisterManagerTitle.
  ///
  /// In en, this message translates to:
  /// **'Manager registration'**
  String get authRegisterManagerTitle;

  /// No description provided for @authOwnerBadge.
  ///
  /// In en, this message translates to:
  /// **'Owner'**
  String get authOwnerBadge;

  /// No description provided for @authManagerBadge.
  ///
  /// In en, this message translates to:
  /// **'Manager'**
  String get authManagerBadge;

  /// No description provided for @authNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get authNameLabel;

  /// No description provided for @authPhoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get authPhoneLabel;

  /// No description provided for @authEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get authEmailLabel;

  /// No description provided for @authInviteCodeLabel.
  ///
  /// In en, this message translates to:
  /// **'Invite code'**
  String get authInviteCodeLabel;

  /// No description provided for @authUsernameLabel.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get authUsernameLabel;

  /// No description provided for @authConfirmPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get authConfirmPasswordLabel;

  /// No description provided for @authVenueNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Venue name'**
  String get authVenueNameLabel;

  /// No description provided for @authVenueNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'Venue number'**
  String get authVenueNumberLabel;

  /// No description provided for @authAgreeTerms.
  ///
  /// In en, this message translates to:
  /// **'I agree to the terms'**
  String get authAgreeTerms;

  /// No description provided for @authAgreeTermsError.
  ///
  /// In en, this message translates to:
  /// **'You must agree to the terms'**
  String get authAgreeTermsError;

  /// No description provided for @authCreateAccount.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get authCreateAccount;

  /// No description provided for @authInviteCodeHint.
  ///
  /// In en, this message translates to:
  /// **'Get the invite code from the hall owner'**
  String get authInviteCodeHint;

  /// No description provided for @authFieldRequired.
  ///
  /// In en, this message translates to:
  /// **'Field must be filled'**
  String get authFieldRequired;

  /// No description provided for @authPasswordMinLength.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters'**
  String get authPasswordMinLength;

  /// No description provided for @authPasswordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get authPasswordsDoNotMatch;

  /// No description provided for @authInvalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email address'**
  String get authInvalidEmail;

  /// No description provided for @authInvalidPhone.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid phone number'**
  String get authInvalidPhone;

  /// No description provided for @authForgotPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Password Recovery'**
  String get authForgotPasswordTitle;

  /// No description provided for @authForgotPasswordBanner.
  ///
  /// In en, this message translates to:
  /// **'Enter your login or email — we\'ll send a link to reset your password.'**
  String get authForgotPasswordBanner;

  /// No description provided for @authForgotPasswordLoginEmailPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'e.g., azamat@mail.kg'**
  String get authForgotPasswordLoginEmailPlaceholder;

  /// No description provided for @authForgotPasswordNoLink.
  ///
  /// In en, this message translates to:
  /// **'Link not arriving?'**
  String get authForgotPasswordNoLink;

  /// No description provided for @authForgotPasswordContactUs.
  ///
  /// In en, this message translates to:
  /// **'Contact us — WhatsApp, Telegram, email, call'**
  String get authForgotPasswordContactUs;

  /// No description provided for @authForgotPasswordSendLink.
  ///
  /// In en, this message translates to:
  /// **'Send link'**
  String get authForgotPasswordSendLink;

  /// No description provided for @authContactSupportTitle.
  ///
  /// In en, this message translates to:
  /// **'Contact Support'**
  String get authContactSupportTitle;

  /// No description provided for @authContactSupportSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Write or call — we\'ll help restore access.'**
  String get authContactSupportSubtitle;

  /// No description provided for @authContactCallLabel.
  ///
  /// In en, this message translates to:
  /// **'Call'**
  String get authContactCallLabel;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navReport.
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get navReport;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @homeCreateVenue.
  ///
  /// In en, this message translates to:
  /// **'Create venue'**
  String get homeCreateVenue;

  /// No description provided for @homeNoVenuesTitle.
  ///
  /// In en, this message translates to:
  /// **'You have no venues yet'**
  String get homeNoVenuesTitle;

  /// No description provided for @homeNoVenuesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Create your first venue to start adding tables and accepting sessions.'**
  String get homeNoVenuesSubtitle;

  /// No description provided for @homeSelectVenue.
  ///
  /// In en, this message translates to:
  /// **'Select venue'**
  String get homeSelectVenue;

  /// No description provided for @homeNewVenue.
  ///
  /// In en, this message translates to:
  /// **'New venue'**
  String get homeNewVenue;

  /// No description provided for @homeAddTable.
  ///
  /// In en, this message translates to:
  /// **'Add table'**
  String get homeAddTable;

  /// No description provided for @homeTablesEmpty.
  ///
  /// In en, this message translates to:
  /// **'No tables yet'**
  String get homeTablesEmpty;

  /// No description provided for @homeTablesEmptySub.
  ///
  /// In en, this message translates to:
  /// **'Add the first table so managers can start sessions.'**
  String get homeTablesEmptySub;

  /// No description provided for @homeTableOccupied.
  ///
  /// In en, this message translates to:
  /// **'OCCUPIED'**
  String get homeTableOccupied;

  /// No description provided for @homeTablePaused.
  ///
  /// In en, this message translates to:
  /// **'PAUSED'**
  String get homeTablePaused;

  /// No description provided for @homeTableFree.
  ///
  /// In en, this message translates to:
  /// **'FREE'**
  String get homeTableFree;

  /// No description provided for @homeTableJustFreed.
  ///
  /// In en, this message translates to:
  /// **'✓ Done'**
  String get homeTableJustFreed;

  /// No description provided for @createTableTitle.
  ///
  /// In en, this message translates to:
  /// **'New table'**
  String get createTableTitle;

  /// No description provided for @createTableNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'Table number'**
  String get createTableNumberLabel;

  /// No description provided for @createTableNumberHint.
  ///
  /// In en, this message translates to:
  /// **'1'**
  String get createTableNumberHint;

  /// No description provided for @createTableNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Table name'**
  String get createTableNameLabel;

  /// No description provided for @createTableNameHint.
  ///
  /// In en, this message translates to:
  /// **'Table 1'**
  String get createTableNameHint;

  /// No description provided for @createTableDescLabel.
  ///
  /// In en, this message translates to:
  /// **'Description (tag)'**
  String get createTableDescLabel;

  /// No description provided for @createTableDescHint.
  ///
  /// In en, this message translates to:
  /// **'VIP room, window seat, snooker...'**
  String get createTableDescHint;

  /// No description provided for @createTableDescPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get createTableDescPlaceholder;

  /// No description provided for @createTableRateLabel.
  ///
  /// In en, this message translates to:
  /// **'Rate'**
  String get createTableRateLabel;

  /// No description provided for @createTableRateSuffix.
  ///
  /// In en, this message translates to:
  /// **'{currency}/{time_unit}'**
  String createTableRateSuffix(Object currency, Object time_unit);

  /// No description provided for @createTableButton.
  ///
  /// In en, this message translates to:
  /// **'Create table'**
  String get createTableButton;

  /// No description provided for @editTableTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit table'**
  String get editTableTitle;

  /// No description provided for @updateTableButton.
  ///
  /// In en, this message translates to:
  /// **'Update table'**
  String get updateTableButton;

  /// No description provided for @deleteTableButton.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get deleteTableButton;

  /// No description provided for @createVenueTitle.
  ///
  /// In en, this message translates to:
  /// **'Create your venue'**
  String get createVenueTitle;

  /// No description provided for @createVenueSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Give your venue a name. Tables can be added later from the home page.'**
  String get createVenueSubtitle;

  /// No description provided for @createVenueNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Venue name'**
  String get createVenueNameLabel;

  /// No description provided for @createVenueNameHint.
  ///
  /// In en, this message translates to:
  /// **'Central branch'**
  String get createVenueNameHint;

  /// No description provided for @createVenueNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'Short code / number (optional)'**
  String get createVenueNumberLabel;

  /// No description provided for @createVenueNumberHint.
  ///
  /// In en, this message translates to:
  /// **'No. 1 or CF'**
  String get createVenueNumberHint;

  /// No description provided for @createVenueInfoBanner.
  ///
  /// In en, this message translates to:
  /// **'After creating the venue you will be able to add tables one by one with their own rate.'**
  String get createVenueInfoBanner;

  /// No description provided for @createVenueButton.
  ///
  /// In en, this message translates to:
  /// **'Create venue →'**
  String get createVenueButton;

  /// No description provided for @editVenueTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit venue'**
  String get editVenueTitle;

  /// No description provided for @updateVenueButton.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get updateVenueButton;

  /// No description provided for @deleteVenueButton.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get deleteVenueButton;

  /// No description provided for @deleteVenueSubtitle.
  ///
  /// In en, this message translates to:
  /// **'All tables and session history will be preserved, but the venue will be removed.'**
  String get deleteVenueSubtitle;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @deleteTableSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Session history will be preserved, but the table will disappear from the home page.'**
  String get deleteTableSubtitle;

  /// No description provided for @generalRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get generalRetry;

  /// No description provided for @createTableTarifTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Tariff type'**
  String get createTableTarifTypeLabel;

  /// No description provided for @tarifTypeMinute.
  ///
  /// In en, this message translates to:
  /// **'Minute'**
  String get tarifTypeMinute;

  /// No description provided for @tarifTypeHour.
  ///
  /// In en, this message translates to:
  /// **'Hour'**
  String get tarifTypeHour;

  /// No description provided for @tarifTypeDay.
  ///
  /// In en, this message translates to:
  /// **'Day'**
  String get tarifTypeDay;

  /// No description provided for @createTableCurrencyLabel.
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get createTableCurrencyLabel;

  /// No description provided for @currencyKgs.
  ///
  /// In en, this message translates to:
  /// **'Som'**
  String get currencyKgs;

  /// No description provided for @currencyUsd.
  ///
  /// In en, this message translates to:
  /// **'Dollar'**
  String get currencyUsd;

  /// No description provided for @currencyRub.
  ///
  /// In en, this message translates to:
  /// **'Ruble'**
  String get currencyRub;

  /// No description provided for @currencyKzt.
  ///
  /// In en, this message translates to:
  /// **'Tenge'**
  String get currencyKzt;

  /// No description provided for @currencyTry.
  ///
  /// In en, this message translates to:
  /// **'Lira'**
  String get currencyTry;

  /// No description provided for @venueTablesCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{no tables} =1{1 table} other{{count} tables}}'**
  String venueTablesCount(int count);

  /// No description provided for @homeTableTitle.
  ///
  /// In en, this message translates to:
  /// **'Table {number}'**
  String homeTableTitle(int number);

  /// No description provided for @homeTablesSection.
  ///
  /// In en, this message translates to:
  /// **'TABLES · {count}'**
  String homeTablesSection(int count);
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'ky', 'ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ky':
      return AppLocalizationsKy();
    case 'ru':
      return AppLocalizationsRu();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
