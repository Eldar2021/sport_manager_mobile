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
