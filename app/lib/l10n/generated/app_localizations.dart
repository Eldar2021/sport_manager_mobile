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

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsAppearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get settingsAppearance;

  /// No description provided for @settingsThemeMode.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get settingsThemeMode;

  /// No description provided for @settingsThemePickerTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose theme'**
  String get settingsThemePickerTitle;

  /// No description provided for @settingsLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguage;

  /// No description provided for @settingsLanguagePickerTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose language'**
  String get settingsLanguagePickerTitle;

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

  /// No description provided for @contactSupportTitle.
  ///
  /// In en, this message translates to:
  /// **'Contact Support'**
  String get contactSupportTitle;

  /// No description provided for @contactSupportSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Write or call — we\'re here to help.'**
  String get contactSupportSubtitle;

  /// No description provided for @contactCallLabel.
  ///
  /// In en, this message translates to:
  /// **'Call'**
  String get contactCallLabel;

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

  /// No description provided for @homeTablesEmptySubManager.
  ///
  /// In en, this message translates to:
  /// **'Tables will appear here once the owner adds them.'**
  String get homeTablesEmptySubManager;

  /// No description provided for @homeTableOccupied.
  ///
  /// In en, this message translates to:
  /// **'{customerName} · OCCUPIED'**
  String homeTableOccupied(String customerName);

  /// No description provided for @homeTableOccupiedBase.
  ///
  /// In en, this message translates to:
  /// **'OCCUPIED'**
  String get homeTableOccupiedBase;

  /// No description provided for @homeTablePaused.
  ///
  /// In en, this message translates to:
  /// **'{customerName} · PAUSED'**
  String homeTablePaused(String customerName);

  /// No description provided for @homeTablePausedBase.
  ///
  /// In en, this message translates to:
  /// **'PAUSED'**
  String get homeTablePausedBase;

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

  /// No description provided for @profileSectionManagement.
  ///
  /// In en, this message translates to:
  /// **'Management'**
  String get profileSectionManagement;

  /// No description provided for @profileManageVenuesTitle.
  ///
  /// In en, this message translates to:
  /// **'Manage venues'**
  String get profileManageVenuesTitle;

  /// No description provided for @profileManageVenuesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No venues} =1{1 venue} other{{count} venues}}'**
  String profileManageVenuesSubtitle(int count);

  /// No description provided for @profileManagersTitle.
  ///
  /// In en, this message translates to:
  /// **'Managers'**
  String get profileManagersTitle;

  /// No description provided for @profileManagersSubtitle.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No managers} =1{1 manager} other{{count} managers}}'**
  String profileManagersSubtitle(int count);

  /// No description provided for @profileSectionAccount.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get profileSectionAccount;

  /// No description provided for @profileSubscriptionTitle.
  ///
  /// In en, this message translates to:
  /// **'Subscription'**
  String get profileSubscriptionTitle;

  /// No description provided for @profileSubscriptionActiveUntil.
  ///
  /// In en, this message translates to:
  /// **'Active · until {date}'**
  String profileSubscriptionActiveUntil(String date);

  /// No description provided for @profileChangePasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Change password'**
  String get profileChangePasswordTitle;

  /// No description provided for @profileSettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get profileSettingsTitle;

  /// No description provided for @profileSettingsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Theme, language'**
  String get profileSettingsSubtitle;

  /// No description provided for @authUpdatePasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Change password'**
  String get authUpdatePasswordTitle;

  /// No description provided for @authUpdatePasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Minimum 8 characters. Use letters, numbers and special characters.'**
  String get authUpdatePasswordHint;

  /// No description provided for @authUpdatePasswordLoginLabel.
  ///
  /// In en, this message translates to:
  /// **'Login / Email'**
  String get authUpdatePasswordLoginLabel;

  /// No description provided for @authUpdatePasswordNewLabel.
  ///
  /// In en, this message translates to:
  /// **'New password'**
  String get authUpdatePasswordNewLabel;

  /// No description provided for @authUpdatePasswordRepeatLabel.
  ///
  /// In en, this message translates to:
  /// **'Repeat new password'**
  String get authUpdatePasswordRepeatLabel;

  /// No description provided for @authUpdatePasswordSubmit.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get authUpdatePasswordSubmit;

  /// No description provided for @authUpdatePasswordSuccess.
  ///
  /// In en, this message translates to:
  /// **'Password updated'**
  String get authUpdatePasswordSuccess;

  /// No description provided for @profileLogout.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get profileLogout;

  /// No description provided for @profileLogoutTitle.
  ///
  /// In en, this message translates to:
  /// **'Log out of account?'**
  String get profileLogoutTitle;

  /// No description provided for @profileLogoutSubtitle.
  ///
  /// In en, this message translates to:
  /// **'You\'ll be redirected to the sign-in screen. Your data will be kept.'**
  String get profileLogoutSubtitle;

  /// No description provided for @profileDeleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete account'**
  String get profileDeleteAccount;

  /// No description provided for @profileDeleteAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete account?'**
  String get profileDeleteAccountTitle;

  /// No description provided for @profileDeleteAccountSubtitle.
  ///
  /// In en, this message translates to:
  /// **'All data, sessions and settings will be permanently deleted. This action cannot be undone.'**
  String get profileDeleteAccountSubtitle;

  /// No description provided for @profileDeleteAccountConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete forever'**
  String get profileDeleteAccountConfirm;

  /// No description provided for @profileErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load profile'**
  String get profileErrorTitle;

  /// No description provided for @profileErrorSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Check your connection and try again.'**
  String get profileErrorSubtitle;

  /// No description provided for @sessionCustomerName.
  ///
  /// In en, this message translates to:
  /// **'Customer name (optional)'**
  String get sessionCustomerName;

  /// No description provided for @sessionCustomerNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. John Smith'**
  String get sessionCustomerNameHint;

  /// No description provided for @tableDetailStart.
  ///
  /// In en, this message translates to:
  /// **'START'**
  String get tableDetailStart;

  /// No description provided for @tableDetailStop.
  ///
  /// In en, this message translates to:
  /// **'STOP & CLOSE'**
  String get tableDetailStop;

  /// No description provided for @tableDetailElapsed.
  ///
  /// In en, this message translates to:
  /// **'ELAPSED'**
  String get tableDetailElapsed;

  /// No description provided for @tableDetailCurrentAmount.
  ///
  /// In en, this message translates to:
  /// **'CURRENT AMOUNT'**
  String get tableDetailCurrentAmount;

  /// No description provided for @tableDetailPause.
  ///
  /// In en, this message translates to:
  /// **'PAUSE'**
  String get tableDetailPause;

  /// No description provided for @tableDetailResume.
  ///
  /// In en, this message translates to:
  /// **'CONTINUE'**
  String get tableDetailResume;

  /// No description provided for @tableDetailStartTime.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get tableDetailStartTime;

  /// No description provided for @tableDetailDuration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get tableDetailDuration;

  /// No description provided for @tableDetailTariff.
  ///
  /// In en, this message translates to:
  /// **'Rate'**
  String get tableDetailTariff;

  /// No description provided for @tableDetailMistakeLaunch.
  ///
  /// In en, this message translates to:
  /// **'Mistake launch'**
  String get tableDetailMistakeLaunch;

  /// No description provided for @tableDetailMistakeLaunchTitle.
  ///
  /// In en, this message translates to:
  /// **'Cancel session?'**
  String get tableDetailMistakeLaunchTitle;

  /// No description provided for @tableDetailMistakeLaunchSubtitle.
  ///
  /// In en, this message translates to:
  /// **'The session will be cancelled. No charge will be applied.'**
  String get tableDetailMistakeLaunchSubtitle;

  /// No description provided for @tableDetailMistakeLaunchConfirm.
  ///
  /// In en, this message translates to:
  /// **'Yes, cancel'**
  String get tableDetailMistakeLaunchConfirm;

  /// No description provided for @tableDetailLastSession.
  ///
  /// In en, this message translates to:
  /// **'Last session'**
  String get tableDetailLastSession;

  /// No description provided for @tableDetailTodaySessions.
  ///
  /// In en, this message translates to:
  /// **'Today\'s sessions'**
  String get tableDetailTodaySessions;

  /// No description provided for @tableDetailPaymentTitle.
  ///
  /// In en, this message translates to:
  /// **'Payment summary'**
  String get tableDetailPaymentTitle;

  /// No description provided for @tableDetailSubtotal.
  ///
  /// In en, this message translates to:
  /// **'Subtotal'**
  String get tableDetailSubtotal;

  /// No description provided for @tableDetailDiscount.
  ///
  /// In en, this message translates to:
  /// **'Discount'**
  String get tableDetailDiscount;

  /// No description provided for @tableDetailToPay.
  ///
  /// In en, this message translates to:
  /// **'TO PAY'**
  String get tableDetailToPay;

  /// No description provided for @tableDetailConfirmAndClose.
  ///
  /// In en, this message translates to:
  /// **'CONFIRM & CLOSE'**
  String get tableDetailConfirmAndClose;

  /// No description provided for @tableDetailDurationMin.
  ///
  /// In en, this message translates to:
  /// **'{count} min'**
  String tableDetailDurationMin(int count);

  /// No description provided for @menuEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get menuEdit;

  /// No description provided for @menuDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get menuDelete;

  /// No description provided for @managersInviteCodeLabel.
  ///
  /// In en, this message translates to:
  /// **'ACTIVE INVITE CODE'**
  String get managersInviteCodeLabel;

  /// No description provided for @managersInviteCodeErrorLabel.
  ///
  /// In en, this message translates to:
  /// **'INVITE CODE UNAVAILABLE'**
  String get managersInviteCodeErrorLabel;

  /// No description provided for @managersInviteCodeCopy.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get managersInviteCodeCopy;

  /// No description provided for @managersInviteCodeCopied.
  ///
  /// In en, this message translates to:
  /// **'Code copied to clipboard'**
  String get managersInviteCodeCopied;

  /// No description provided for @managersSectionLabel.
  ///
  /// In en, this message translates to:
  /// **'MANAGERS'**
  String get managersSectionLabel;

  /// No description provided for @managersInviteAction.
  ///
  /// In en, this message translates to:
  /// **'Invite manager'**
  String get managersInviteAction;

  /// No description provided for @managersDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Remove {name}?'**
  String managersDeleteTitle(String name);

  /// No description provided for @managersDeleteSubtitle.
  ///
  /// In en, this message translates to:
  /// **'The manager will lose access to your venues. Their session history is kept.'**
  String get managersDeleteSubtitle;

  /// No description provided for @managersEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No managers yet'**
  String get managersEmptyTitle;

  /// No description provided for @managersEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Share the invite code so a manager can sign up and start working shifts.'**
  String get managersEmptySubtitle;

  /// No description provided for @managersLastSeenJustNow.
  ///
  /// In en, this message translates to:
  /// **'online now'**
  String get managersLastSeenJustNow;

  /// No description provided for @managersLastSeenMinutes.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 min ago} other{{count} min ago}}'**
  String managersLastSeenMinutes(int count);

  /// No description provided for @managersLastSeenHours.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 hour ago} other{{count} hours ago}}'**
  String managersLastSeenHours(int count);

  /// No description provided for @managersLastSeenDays.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 day ago} other{{count} days ago}}'**
  String managersLastSeenDays(int count);

  /// No description provided for @venueMetricTablesLabel.
  ///
  /// In en, this message translates to:
  /// **'TABLES'**
  String get venueMetricTablesLabel;

  /// No description provided for @venueDetailTablesHeader.
  ///
  /// In en, this message translates to:
  /// **'HALL TABLES'**
  String get venueDetailTablesHeader;

  /// No description provided for @venueTablesCountSuffix.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{0 pcs} =1{1 pc} other{{count} pcs}}'**
  String venueTablesCountSuffix(int count);

  /// No description provided for @subscriptionTitle.
  ///
  /// In en, this message translates to:
  /// **'Subscription'**
  String get subscriptionTitle;

  /// No description provided for @subscriptionStatusActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get subscriptionStatusActive;

  /// No description provided for @subscriptionStatusGrace.
  ///
  /// In en, this message translates to:
  /// **'Grace period'**
  String get subscriptionStatusGrace;

  /// No description provided for @subscriptionStatusExpired.
  ///
  /// In en, this message translates to:
  /// **'Expired'**
  String get subscriptionStatusExpired;

  /// No description provided for @subscriptionSourceTrial.
  ///
  /// In en, this message translates to:
  /// **'Free trial'**
  String get subscriptionSourceTrial;

  /// No description provided for @subscriptionSourcePaid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get subscriptionSourcePaid;

  /// No description provided for @subscriptionWarningBanner.
  ///
  /// In en, this message translates to:
  /// **'{n, plural, =1{Your subscription expires in 1 day. Renew to avoid interruption.} other{Your subscription expires in {n} days. Renew to avoid interruption.}}'**
  String subscriptionWarningBanner(int n);

  /// No description provided for @subscriptionGraceBanner.
  ///
  /// In en, this message translates to:
  /// **'{n, plural, =1{Subscription expired. 1 day of grace period left.} other{Subscription expired. {n} days of grace period left.}}'**
  String subscriptionGraceBanner(int n);

  /// No description provided for @subscriptionExpiredBanner.
  ///
  /// In en, this message translates to:
  /// **'Subscription expired. Renew to use core features.'**
  String get subscriptionExpiredBanner;

  /// No description provided for @subscriptionPlanCardPerTable.
  ///
  /// In en, this message translates to:
  /// **'{price} {currency} / table / month'**
  String subscriptionPlanCardPerTable(int price, String currency);

  /// No description provided for @subscriptionPlanCardMonthly.
  ///
  /// In en, this message translates to:
  /// **'× {tableCount} tables = {monthly} {currency} / month'**
  String subscriptionPlanCardMonthly(int tableCount, int monthly, String currency);

  /// No description provided for @subscriptionDetailNextPayment.
  ///
  /// In en, this message translates to:
  /// **'Next payment'**
  String get subscriptionDetailNextPayment;

  /// No description provided for @subscriptionDetailLastPayment.
  ///
  /// In en, this message translates to:
  /// **'Last payment'**
  String get subscriptionDetailLastPayment;

  /// No description provided for @subscriptionDetailStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get subscriptionDetailStatus;

  /// No description provided for @subscriptionPaymentHistoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Payment history'**
  String get subscriptionPaymentHistoryTitle;

  /// No description provided for @subscriptionPaymentHistoryEmpty.
  ///
  /// In en, this message translates to:
  /// **'No payments yet'**
  String get subscriptionPaymentHistoryEmpty;

  /// No description provided for @subscriptionPaymentItemSummary.
  ///
  /// In en, this message translates to:
  /// **'{months} months × {tableCount} tables'**
  String subscriptionPaymentItemSummary(int months, int tableCount);

  /// No description provided for @subscriptionAmountWithCurrency.
  ///
  /// In en, this message translates to:
  /// **'{amount} {currency}'**
  String subscriptionAmountWithCurrency(int amount, String currency);

  /// No description provided for @subscriptionContinueCta.
  ///
  /// In en, this message translates to:
  /// **'Continue subscription'**
  String get subscriptionContinueCta;

  /// No description provided for @subscriptionCheckoutTitle.
  ///
  /// In en, this message translates to:
  /// **'Checkout'**
  String get subscriptionCheckoutTitle;

  /// No description provided for @subscriptionCheckoutSummary.
  ///
  /// In en, this message translates to:
  /// **'{tableCount} tables × {price} {currency} = {monthly} {currency} / month'**
  String subscriptionCheckoutSummary(int tableCount, int price, int monthly, String currency);

  /// No description provided for @subscriptionCheckoutDuration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get subscriptionCheckoutDuration;

  /// No description provided for @subscriptionCheckoutMonthsLabel.
  ///
  /// In en, this message translates to:
  /// **'{n, plural, =1{1 month} other{{n} months}}'**
  String subscriptionCheckoutMonthsLabel(int n);

  /// No description provided for @subscriptionCheckoutTotal.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get subscriptionCheckoutTotal;

  /// No description provided for @subscriptionCheckoutTotalLine.
  ///
  /// In en, this message translates to:
  /// **'{months} months × {monthly} {currency} = {total} {currency}'**
  String subscriptionCheckoutTotalLine(int months, int monthly, int total, String currency);

  /// No description provided for @subscriptionCheckoutNewEndDate.
  ///
  /// In en, this message translates to:
  /// **'New end date: {date}'**
  String subscriptionCheckoutNewEndDate(String date);

  /// No description provided for @subscriptionCheckoutPay.
  ///
  /// In en, this message translates to:
  /// **'Pay'**
  String get subscriptionCheckoutPay;

  /// No description provided for @subscriptionCheckoutNoTablesTitle.
  ///
  /// In en, this message translates to:
  /// **'No tables yet'**
  String get subscriptionCheckoutNoTablesTitle;

  /// No description provided for @subscriptionCheckoutNoTablesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Add at least one table to subscribe.'**
  String get subscriptionCheckoutNoTablesSubtitle;

  /// No description provided for @subscriptionCheckoutGoToVenues.
  ///
  /// In en, this message translates to:
  /// **'Go to venues'**
  String get subscriptionCheckoutGoToVenues;

  /// No description provided for @subscriptionPaymentMockTitle.
  ///
  /// In en, this message translates to:
  /// **'Mock payment'**
  String get subscriptionPaymentMockTitle;

  /// No description provided for @subscriptionPaymentMockSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Real payment integration is coming soon. Simulate the outcome below.'**
  String get subscriptionPaymentMockSubtitle;

  /// No description provided for @subscriptionPaymentSimulateSuccess.
  ///
  /// In en, this message translates to:
  /// **'Simulate success'**
  String get subscriptionPaymentSimulateSuccess;

  /// No description provided for @subscriptionPaymentSimulateFailure.
  ///
  /// In en, this message translates to:
  /// **'Simulate failure'**
  String get subscriptionPaymentSimulateFailure;

  /// No description provided for @subscriptionPaymentSuccessTitle.
  ///
  /// In en, this message translates to:
  /// **'Payment successful'**
  String get subscriptionPaymentSuccessTitle;

  /// No description provided for @subscriptionPaymentSuccessBody.
  ///
  /// In en, this message translates to:
  /// **'Subscription extended until {date}.'**
  String subscriptionPaymentSuccessBody(String date);

  /// No description provided for @subscriptionPaymentFailedTitle.
  ///
  /// In en, this message translates to:
  /// **'Payment failed'**
  String get subscriptionPaymentFailedTitle;

  /// No description provided for @subscriptionPaymentFailedBody.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong with the payment. Please try again.'**
  String get subscriptionPaymentFailedBody;

  /// No description provided for @subscriptionPaymentRetry.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get subscriptionPaymentRetry;

  /// No description provided for @subscriptionPaymentClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get subscriptionPaymentClose;

  /// No description provided for @subscriptionBlockedTitle.
  ///
  /// In en, this message translates to:
  /// **'Subscription required'**
  String get subscriptionBlockedTitle;

  /// No description provided for @subscriptionBlockedSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Renew your subscription to use core features.'**
  String get subscriptionBlockedSubtitle;

  /// No description provided for @subscriptionBlockedRenew.
  ///
  /// In en, this message translates to:
  /// **'Renew now'**
  String get subscriptionBlockedRenew;

  /// No description provided for @subscriptionBlockedCancel.
  ///
  /// In en, this message translates to:
  /// **'Not now'**
  String get subscriptionBlockedCancel;

  /// No description provided for @subscriptionErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load subscription'**
  String get subscriptionErrorTitle;

  /// No description provided for @subscriptionErrorSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Check your connection and try again.'**
  String get subscriptionErrorSubtitle;

  /// No description provided for @subscriptionContactSupportAction.
  ///
  /// In en, this message translates to:
  /// **'Need help? Contact support'**
  String get subscriptionContactSupportAction;

  /// No description provided for @profileSubscriptionExpiresIn.
  ///
  /// In en, this message translates to:
  /// **'{n, plural, =1{Expires in 1 day} other{Expires in {n} days}}'**
  String profileSubscriptionExpiresIn(int n);

  /// No description provided for @profileSubscriptionGrace.
  ///
  /// In en, this message translates to:
  /// **'{n, plural, =1{Grace · 1 day left} other{Grace · {n} days left}}'**
  String profileSubscriptionGrace(int n);

  /// No description provided for @profileSubscriptionExpired.
  ///
  /// In en, this message translates to:
  /// **'Expired'**
  String get profileSubscriptionExpired;

  /// No description provided for @reportsOverviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get reportsOverviewTitle;

  /// No description provided for @reportsManagerDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Manager'**
  String get reportsManagerDetailTitle;

  /// No description provided for @reportsTableDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Table'**
  String get reportsTableDetailTitle;

  /// No description provided for @reportsPeriodToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get reportsPeriodToday;

  /// No description provided for @reportsPeriodWeek.
  ///
  /// In en, this message translates to:
  /// **'Week'**
  String get reportsPeriodWeek;

  /// No description provided for @reportsPeriodMonth.
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get reportsPeriodMonth;

  /// No description provided for @reportsPeriodYear.
  ///
  /// In en, this message translates to:
  /// **'Year'**
  String get reportsPeriodYear;

  /// No description provided for @reportsPeriodCustom.
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get reportsPeriodCustom;

  /// No description provided for @reportsVenuePickerTitle.
  ///
  /// In en, this message translates to:
  /// **'Pick a venue'**
  String get reportsVenuePickerTitle;

  /// No description provided for @reportsKpiRevenue.
  ///
  /// In en, this message translates to:
  /// **'Total revenue'**
  String get reportsKpiRevenue;

  /// No description provided for @reportsKpiSessions.
  ///
  /// In en, this message translates to:
  /// **'Sessions'**
  String get reportsKpiSessions;

  /// No description provided for @reportsRevenueChartTitle.
  ///
  /// In en, this message translates to:
  /// **'Revenue by day'**
  String get reportsRevenueChartTitle;

  /// No description provided for @reportsRevenueChartCompareToggle.
  ///
  /// In en, this message translates to:
  /// **'Compare to previous period'**
  String get reportsRevenueChartCompareToggle;

  /// No description provided for @reportsTablesTitle.
  ///
  /// In en, this message translates to:
  /// **'Tables'**
  String get reportsTablesTitle;

  /// No description provided for @reportsTopManagersTitle.
  ///
  /// In en, this message translates to:
  /// **'Managers'**
  String get reportsTopManagersTitle;

  /// No description provided for @reportsTableLabel.
  ///
  /// In en, this message translates to:
  /// **'Table'**
  String get reportsTableLabel;

  /// No description provided for @reportsSessionsShort.
  ///
  /// In en, this message translates to:
  /// **'sessions'**
  String get reportsSessionsShort;

  /// No description provided for @reportsCancelledShort.
  ///
  /// In en, this message translates to:
  /// **'cancels'**
  String get reportsCancelledShort;

  /// No description provided for @reportsSessionLogTitle.
  ///
  /// In en, this message translates to:
  /// **'Session log'**
  String get reportsSessionLogTitle;

  /// No description provided for @reportsLogFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get reportsLogFilterAll;

  /// No description provided for @reportsLogFilterCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get reportsLogFilterCancelled;

  /// No description provided for @reportsLogStatusActive.
  ///
  /// In en, this message translates to:
  /// **'In progress'**
  String get reportsLogStatusActive;

  /// No description provided for @reportsLogEmpty.
  ///
  /// In en, this message translates to:
  /// **'No sessions match this filter.'**
  String get reportsLogEmpty;

  /// No description provided for @reportsForecastSummaryTitle.
  ///
  /// In en, this message translates to:
  /// **'Forecast'**
  String get reportsForecastSummaryTitle;

  /// No description provided for @reportsForecastVsPrevious.
  ///
  /// In en, this message translates to:
  /// **'vs previous period'**
  String get reportsForecastVsPrevious;

  /// No description provided for @reportsForecastVsRange.
  ///
  /// In en, this message translates to:
  /// **'vs {previous}'**
  String reportsForecastVsRange(String previous);

  /// No description provided for @reportsForecastNoComparison.
  ///
  /// In en, this message translates to:
  /// **'Not enough history yet'**
  String get reportsForecastNoComparison;

  /// No description provided for @reportsComparisonCaption.
  ///
  /// In en, this message translates to:
  /// **'{current}  ·  vs {previous}'**
  String reportsComparisonCaption(String current, String previous);

  /// No description provided for @reportsTableTrendTitle.
  ///
  /// In en, this message translates to:
  /// **'Revenue trend'**
  String get reportsTableTrendTitle;

  /// No description provided for @reportsTableHeatmapTitle.
  ///
  /// In en, this message translates to:
  /// **'Hour-of-day heatmap'**
  String get reportsTableHeatmapTitle;

  /// No description provided for @reportsErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load report'**
  String get reportsErrorTitle;

  /// No description provided for @reportsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No data yet'**
  String get reportsEmptyTitle;

  /// No description provided for @reportsEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Start sessions to populate this report.'**
  String get reportsEmptySubtitle;

  /// No description provided for @upgraderRequiredTitle.
  ///
  /// In en, this message translates to:
  /// **'Update Required'**
  String get upgraderRequiredTitle;

  /// No description provided for @upgraderRecommendedTitle.
  ///
  /// In en, this message translates to:
  /// **'Update Available'**
  String get upgraderRecommendedTitle;

  /// No description provided for @upgraderRequiredDescription.
  ///
  /// In en, this message translates to:
  /// **'This version is no longer supported. Please update the app to continue.'**
  String get upgraderRequiredDescription;

  /// No description provided for @upgraderRecommendedDescription.
  ///
  /// In en, this message translates to:
  /// **'A new version is available. Update for the best experience.'**
  String get upgraderRecommendedDescription;

  /// No description provided for @upgraderUpdateButton.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get upgraderUpdateButton;

  /// No description provided for @upgraderLaterButton.
  ///
  /// In en, this message translates to:
  /// **'Later'**
  String get upgraderLaterButton;

  /// No description provided for @currencyLabel.
  ///
  /// In en, this message translates to:
  /// **'som'**
  String get currencyLabel;

  /// No description provided for @profileProductsTitle.
  ///
  /// In en, this message translates to:
  /// **'Products and prices'**
  String get profileProductsTitle;

  /// No description provided for @profileProductsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Drinks, food, rent'**
  String get profileProductsSubtitle;

  /// No description provided for @productsTitle.
  ///
  /// In en, this message translates to:
  /// **'Products'**
  String get productsTitle;

  /// No description provided for @productsAddButton.
  ///
  /// In en, this message translates to:
  /// **'Add product'**
  String get productsAddButton;

  /// No description provided for @productsCreateTitle.
  ///
  /// In en, this message translates to:
  /// **'New product'**
  String get productsCreateTitle;

  /// No description provided for @productsEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit product'**
  String get productsEditTitle;

  /// No description provided for @productsCreateButton.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get productsCreateButton;

  /// No description provided for @productsUpdateButton.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get productsUpdateButton;

  /// No description provided for @productsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No products yet'**
  String get productsEmptyTitle;

  /// No description provided for @productsEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Add your first product to start selling.'**
  String get productsEmptySubtitle;

  /// No description provided for @productsDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete \"{name}\"?'**
  String productsDeleteTitle(String name);

  /// No description provided for @productsDeleteSubtitle.
  ///
  /// In en, this message translates to:
  /// **'This product will be soft-deleted and won\'t appear in active sessions.'**
  String get productsDeleteSubtitle;

  /// No description provided for @productsNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get productsNameLabel;

  /// No description provided for @productsNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Water 0.5L'**
  String get productsNameHint;

  /// No description provided for @productsPriceLabel.
  ///
  /// In en, this message translates to:
  /// **'Price (som)'**
  String get productsPriceLabel;

  /// No description provided for @productsPriceHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 50'**
  String get productsPriceHint;

  /// No description provided for @productsPriceInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid price greater than 0'**
  String get productsPriceInvalid;

  /// No description provided for @productsCategoryLabel.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get productsCategoryLabel;

  /// No description provided for @productsUnitLabel.
  ///
  /// In en, this message translates to:
  /// **'Unit'**
  String get productsUnitLabel;

  /// No description provided for @productsDescriptionLabel.
  ///
  /// In en, this message translates to:
  /// **'Description (optional)'**
  String get productsDescriptionLabel;

  /// No description provided for @productsDescriptionHint.
  ///
  /// In en, this message translates to:
  /// **'Short description...'**
  String get productsDescriptionHint;

  /// No description provided for @productsPhotoPickerLabel.
  ///
  /// In en, this message translates to:
  /// **'Tap to add photo'**
  String get productsPhotoPickerLabel;

  /// No description provided for @productCategoryDrink.
  ///
  /// In en, this message translates to:
  /// **'Drink'**
  String get productCategoryDrink;

  /// No description provided for @productCategoryFood.
  ///
  /// In en, this message translates to:
  /// **'Food'**
  String get productCategoryFood;

  /// No description provided for @productCategoryEquipment.
  ///
  /// In en, this message translates to:
  /// **'Equipment'**
  String get productCategoryEquipment;

  /// No description provided for @productCategoryOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get productCategoryOther;

  /// No description provided for @productUnitPiece.
  ///
  /// In en, this message translates to:
  /// **'Piece'**
  String get productUnitPiece;

  /// No description provided for @productUnitKg.
  ///
  /// In en, this message translates to:
  /// **'kg'**
  String get productUnitKg;

  /// No description provided for @productUnitLitre.
  ///
  /// In en, this message translates to:
  /// **'Litre'**
  String get productUnitLitre;

  /// No description provided for @productUnitPortion.
  ///
  /// In en, this message translates to:
  /// **'Portion'**
  String get productUnitPortion;

  /// No description provided for @productUnitHour.
  ///
  /// In en, this message translates to:
  /// **'Hour'**
  String get productUnitHour;
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
