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
  String get settingsTitle => 'Settings';

  @override
  String get settingsAppearance => 'Appearance';

  @override
  String get settingsThemeMode => 'Theme';

  @override
  String get settingsThemePickerTitle => 'Choose theme';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsLanguagePickerTitle => 'Choose language';

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
  String get contactSupportTitle => 'Contact Support';

  @override
  String get contactSupportSubtitle => 'Write or call — we\'re here to help.';

  @override
  String get contactCallLabel => 'Call';

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
  String get homeNoVenuesSubtitle => 'Create your first venue to start adding spots and accepting sessions.';

  @override
  String get homeSelectVenue => 'Select venue';

  @override
  String get homeNewVenue => 'New venue';

  @override
  String homeAddSpot(String spot) {
    return 'Add $spot';
  }

  @override
  String homeSpotsEmpty(String spotPlural) {
    return 'No $spotPlural yet';
  }

  @override
  String homeSpotsEmptySub(String spot) {
    return 'Add the first $spot so managers can start sessions.';
  }

  @override
  String homeSpotsEmptySubManager(String spotPlural) {
    return '$spotPlural will appear here once the owner adds them.';
  }

  @override
  String homeSpotOccupied(String customerName) {
    return '$customerName · OCCUPIED';
  }

  @override
  String get homeSpotOccupiedBase => 'OCCUPIED';

  @override
  String homeSpotPaused(String customerName) {
    return '$customerName · PAUSED';
  }

  @override
  String get homeSpotPausedBase => 'PAUSED';

  @override
  String get homeSpotFree => 'FREE';

  @override
  String get homeSpotJustFreed => '✓ Done';

  @override
  String get createSpotTitle => 'New spot';

  @override
  String get createSpotNumberLabel => 'Spot number';

  @override
  String get createSpotNumberHint => '1';

  @override
  String get createSpotNameLabel => 'Spot name';

  @override
  String get createSpotNameHint => 'Spot 1';

  @override
  String get createSpotDescLabel => 'Description (tag)';

  @override
  String get createSpotDescHint => 'VIP, window seat, snooker...';

  @override
  String get createSpotDescPlaceholder => 'Description';

  @override
  String get createSpotRateLabel => 'Rate';

  @override
  String createSpotRateSuffix(String currency, String time_unit) {
    return '$currency/$time_unit';
  }

  @override
  String get createSpotButton => 'Create spot';

  @override
  String get editSpotTitle => 'Edit spot';

  @override
  String get updateSpotButton => 'Update spot';

  @override
  String get deleteSpotButton => 'Delete';

  @override
  String get deleteSpotSubtitle => 'Session history will be preserved, but the spot will disappear from the home page.';

  @override
  String get createVenueTitle => 'Create your venue';

  @override
  String get createVenueSubtitle => 'Give your venue a name. Spots can be added later from the home page.';

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
      'After creating the venue you will be able to add spots one by one with their own rate.';

  @override
  String get createVenueButton => 'Create venue →';

  @override
  String get editVenueTitle => 'Edit venue';

  @override
  String get updateVenueButton => 'Update';

  @override
  String get deleteVenueButton => 'Delete';

  @override
  String get deleteVenueSubtitle => 'All spots and session history will be preserved, but the venue will be removed.';

  @override
  String get cancel => 'Cancel';

  @override
  String get generalRetry => 'Retry';

  @override
  String get createSpotTarifTypeLabel => 'Tariff type';

  @override
  String get tarifTypeMinute => 'Minute';

  @override
  String get tarifTypeHour => 'Hour';

  @override
  String get tarifTypeDay => 'Day';

  @override
  String get createSpotCurrencyLabel => 'Currency';

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
  String venueSpotsCount(int count, String spot, String spotPlural) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count $spotPlural',
      one: '1 $spot',
      zero: 'no $spotPlural',
    );
    return '$_temp0';
  }

  @override
  String homeSpotTitle(String spotLabel, int number) {
    return '$spotLabel $number';
  }

  @override
  String homeSpotsSection(String spotPlural, int count) {
    return '$spotPlural · $count';
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
  String get profileSettingsTitle => 'Settings';

  @override
  String get profileSettingsSubtitle => 'Theme, language';

  @override
  String get authUpdatePasswordTitle => 'Change password';

  @override
  String get authUpdatePasswordHint => 'Minimum 8 characters. Use letters, numbers and special characters.';

  @override
  String get authUpdatePasswordLoginLabel => 'Login / Email';

  @override
  String get authUpdatePasswordNewLabel => 'New password';

  @override
  String get authUpdatePasswordRepeatLabel => 'Repeat new password';

  @override
  String get authUpdatePasswordSubmit => 'Save';

  @override
  String get authUpdatePasswordSuccess => 'Password updated';

  @override
  String get profileLogout => 'Log out';

  @override
  String get profileLogoutTitle => 'Log out of account?';

  @override
  String get profileLogoutSubtitle => 'You\'ll be redirected to the sign-in screen. Your data will be kept.';

  @override
  String get profileDeleteAccount => 'Delete account';

  @override
  String get profileDeleteAccountTitle => 'Delete account?';

  @override
  String get profileDeleteAccountSubtitle =>
      'All data, sessions and settings will be permanently deleted. This action cannot be undone.';

  @override
  String get profileDeleteAccountConfirm => 'Delete forever';

  @override
  String get profileErrorTitle => 'Couldn\'t load profile';

  @override
  String get profileErrorSubtitle => 'Check your connection and try again.';

  @override
  String get sessionCustomerName => 'Customer name (optional)';

  @override
  String get sessionCustomerNameHint => 'e.g. John Smith';

  @override
  String get spotDetailStart => 'START';

  @override
  String get spotDetailStop => 'STOP & CLOSE';

  @override
  String get spotDetailElapsed => 'ELAPSED';

  @override
  String get spotDetailCurrentAmount => 'CURRENT AMOUNT';

  @override
  String get spotDetailPause => 'PAUSE';

  @override
  String get spotDetailResume => 'CONTINUE';

  @override
  String get spotDetailStartTime => 'Start';

  @override
  String get spotDetailDuration => 'Duration';

  @override
  String get spotDetailTariff => 'Rate';

  @override
  String get spotDetailMistakeLaunch => 'Mistake launch';

  @override
  String get spotDetailMistakeLaunchTitle => 'Cancel session?';

  @override
  String get spotDetailMistakeLaunchSubtitle => 'The session will be cancelled. No charge will be applied.';

  @override
  String get spotDetailMistakeLaunchConfirm => 'Yes, cancel';

  @override
  String get spotDetailLastSession => 'Last session';

  @override
  String get spotDetailTodaySessions => 'Today\'s sessions';

  @override
  String get spotDetailPaymentTitle => 'Payment summary';

  @override
  String get spotDetailSubtotal => 'Subtotal';

  @override
  String get spotDetailDiscount => 'Discount';

  @override
  String get spotDetailToPay => 'TO PAY';

  @override
  String get spotDetailConfirmAndClose => 'CONFIRM & CLOSE';

  @override
  String spotDetailDurationMin(int count) {
    return '$count min';
  }

  @override
  String get spotLabelSpot => 'Spot';

  @override
  String get spotLabelConsole => 'Console';

  @override
  String get spotLabelCourt => 'Court';

  @override
  String get spotLabelBoard => 'Board';

  @override
  String get spotLabelPitch => 'Pitch';

  @override
  String get spotLabelSpotPlural => 'Spots';

  @override
  String get spotLabelConsolePlural => 'Consoles';

  @override
  String get spotLabelCourtPlural => 'Courts';

  @override
  String get spotLabelBoardPlural => 'Boards';

  @override
  String get spotLabelPitchPlural => 'Pitches';

  @override
  String get venueTypeSpotTennis => 'Spot Tennis';

  @override
  String get venueTypeBilliards => 'Billiards';

  @override
  String get venueTypePlayStation => 'PlayStation';

  @override
  String get venueTypeVolleyball => 'Volleyball';

  @override
  String get venueTypeBasketball => 'Basketball';

  @override
  String get venueTypeChess => 'Chess';

  @override
  String get venueTypeFootball => 'Football';

  @override
  String get venueFormTypeLabel => 'Type';

  @override
  String get venueFormTypeImmutableHint =>
      'Type can\'t be changed after creation. Create a new venue if you switch sports.';

  @override
  String get venueFormTypeRequiredError => 'Please select a venue type';

  @override
  String get menuEdit => 'Edit';

  @override
  String get menuDelete => 'Delete';

  @override
  String get managersInviteCodeLabel => 'ACTIVE INVITE CODE';

  @override
  String get managersInviteCodeErrorLabel => 'INVITE CODE UNAVAILABLE';

  @override
  String get managersInviteCodeCopy => 'Copy';

  @override
  String get managersInviteCodeCopied => 'Code copied to clipboard';

  @override
  String get managersSectionLabel => 'MANAGERS';

  @override
  String get managersInviteAction => 'Invite manager';

  @override
  String managersDeleteTitle(String name) {
    return 'Remove $name?';
  }

  @override
  String get managersDeleteSubtitle => 'The manager will lose access to your venues. Their session history is kept.';

  @override
  String get managersEmptyTitle => 'No managers yet';

  @override
  String get managersEmptySubtitle => 'Share the invite code so a manager can sign up and start working shifts.';

  @override
  String get managersLastSeenJustNow => 'online now';

  @override
  String managersLastSeenMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count min ago',
      one: '1 min ago',
    );
    return '$_temp0';
  }

  @override
  String managersLastSeenHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count hours ago',
      one: '1 hour ago',
    );
    return '$_temp0';
  }

  @override
  String managersLastSeenDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days ago',
      one: '1 day ago',
    );
    return '$_temp0';
  }

  @override
  String venueSpotsCountSuffix(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pcs',
      one: '1 pc',
      zero: '0 pcs',
    );
    return '$_temp0';
  }

  @override
  String get subscriptionTitle => 'Subscription';

  @override
  String get subscriptionStatusActive => 'Active';

  @override
  String get subscriptionStatusGrace => 'Grace period';

  @override
  String get subscriptionStatusExpired => 'Expired';

  @override
  String get subscriptionSourceTrial => 'Free trial';

  @override
  String get subscriptionSourcePaid => 'Paid';

  @override
  String subscriptionWarningBanner(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'Your subscription expires in $n days. Renew to avoid interruption.',
      one: 'Your subscription expires in 1 day. Renew to avoid interruption.',
    );
    return '$_temp0';
  }

  @override
  String subscriptionGraceBanner(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'Subscription expired. $n days of grace period left.',
      one: 'Subscription expired. 1 day of grace period left.',
    );
    return '$_temp0';
  }

  @override
  String get subscriptionExpiredBanner => 'Subscription expired. Renew to use core features.';

  @override
  String subscriptionPlanCardPerSpot(int price, String currency) {
    return '$price $currency / spot / month';
  }

  @override
  String subscriptionPlanCardMonthly(int tableCount, int monthly, String currency) {
    return '× $tableCount spots = $monthly $currency / month';
  }

  @override
  String get subscriptionDetailNextPayment => 'Next payment';

  @override
  String get subscriptionDetailLastPayment => 'Last payment';

  @override
  String get subscriptionDetailStatus => 'Status';

  @override
  String get subscriptionPaymentHistoryTitle => 'Payment history';

  @override
  String get subscriptionPaymentHistoryEmpty => 'No payments yet';

  @override
  String subscriptionPaymentItemSummary(int months, int tableCount) {
    return '$months months × $tableCount spots';
  }

  @override
  String subscriptionAmountWithCurrency(int amount, String currency) {
    return '$amount $currency';
  }

  @override
  String get subscriptionContinueCta => 'Continue subscription';

  @override
  String get subscriptionCheckoutTitle => 'Checkout';

  @override
  String subscriptionCheckoutSummary(int tableCount, int price, int monthly, String currency) {
    return '$tableCount spots × $price $currency = $monthly $currency / month';
  }

  @override
  String get subscriptionCheckoutDuration => 'Duration';

  @override
  String subscriptionCheckoutMonthsLabel(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n months',
      one: '1 month',
    );
    return '$_temp0';
  }

  @override
  String get subscriptionCheckoutTotal => 'Total';

  @override
  String subscriptionCheckoutTotalLine(int months, int monthly, int total, String currency) {
    return '$months months × $monthly $currency = $total $currency';
  }

  @override
  String subscriptionCheckoutNewEndDate(String date) {
    return 'New end date: $date';
  }

  @override
  String get subscriptionCheckoutPay => 'Pay';

  @override
  String get subscriptionCheckoutNoSpotsTitle => 'No spots yet';

  @override
  String get subscriptionCheckoutNoSpotsSubtitle => 'Add at least one spot to subscribe.';

  @override
  String get subscriptionCheckoutGoToVenues => 'Go to venues';

  @override
  String get subscriptionPaymentMockTitle => 'Mock payment';

  @override
  String get subscriptionPaymentMockSubtitle => 'Real payment integration is coming soon. Simulate the outcome below.';

  @override
  String get subscriptionPaymentSimulateSuccess => 'Simulate success';

  @override
  String get subscriptionPaymentSimulateFailure => 'Simulate failure';

  @override
  String get subscriptionPaymentSuccessTitle => 'Payment successful';

  @override
  String subscriptionPaymentSuccessBody(String date) {
    return 'Subscription extended until $date.';
  }

  @override
  String get subscriptionPaymentFailedTitle => 'Payment failed';

  @override
  String get subscriptionPaymentFailedBody => 'Something went wrong with the payment. Please try again.';

  @override
  String get subscriptionPaymentRetry => 'Try again';

  @override
  String get subscriptionPaymentClose => 'Close';

  @override
  String get subscriptionBlockedTitle => 'Subscription required';

  @override
  String get subscriptionBlockedSubtitle => 'Renew your subscription to use core features.';

  @override
  String get subscriptionBlockedRenew => 'Renew now';

  @override
  String get subscriptionBlockedCancel => 'Not now';

  @override
  String get subscriptionErrorTitle => 'Couldn\'t load subscription';

  @override
  String get subscriptionErrorSubtitle => 'Check your connection and try again.';

  @override
  String get subscriptionContactSupportAction => 'Need help? Contact support';

  @override
  String profileSubscriptionExpiresIn(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'Expires in $n days',
      one: 'Expires in 1 day',
    );
    return '$_temp0';
  }

  @override
  String profileSubscriptionGrace(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'Grace · $n days left',
      one: 'Grace · 1 day left',
    );
    return '$_temp0';
  }

  @override
  String get profileSubscriptionExpired => 'Expired';

  @override
  String get reportsOverviewTitle => 'Reports';

  @override
  String get reportsManagerDetailTitle => 'Manager';

  @override
  String get reportsSpotDetailTitle => 'Spot';

  @override
  String get reportsPeriodToday => 'Today';

  @override
  String get reportsPeriodWeek => 'Week';

  @override
  String get reportsPeriodMonth => 'Month';

  @override
  String get reportsPeriodYear => 'Year';

  @override
  String get reportsPeriodCustom => 'Custom';

  @override
  String get reportsVenuePickerTitle => 'Pick a venue';

  @override
  String get reportsKpiRevenue => 'Total revenue';

  @override
  String get reportsKpiSessions => 'Sessions';

  @override
  String get reportsRevenueChartTitle => 'Revenue by day';

  @override
  String get reportsRevenueChartCompareToggle => 'Compare to previous period';

  @override
  String get reportsTopManagersTitle => 'Managers';

  @override
  String get reportsSpotLabel => 'Spot';

  @override
  String get reportsSessionsShort => 'sessions';

  @override
  String get reportsCancelledShort => 'cancels';

  @override
  String get reportsSessionLogTitle => 'Session log';

  @override
  String get reportsLogFilterAll => 'All';

  @override
  String get reportsLogFilterCancelled => 'Cancelled';

  @override
  String get reportsLogStatusActive => 'In progress';

  @override
  String get reportsLogEmpty => 'No sessions match this filter.';

  @override
  String get reportsForecastSummaryTitle => 'Forecast';

  @override
  String get reportsForecastVsPrevious => 'vs previous period';

  @override
  String reportsForecastVsRange(String previous) {
    return 'vs $previous';
  }

  @override
  String get reportsForecastNoComparison => 'Not enough history yet';

  @override
  String reportsComparisonCaption(String current, String previous) {
    return '$current  ·  vs $previous';
  }

  @override
  String get reportsSpotTrendTitle => 'Revenue trend';

  @override
  String get reportsSpotHeatmapTitle => 'Hour-of-day heatmap';

  @override
  String get reportsErrorTitle => 'Couldn\'t load report';

  @override
  String get reportsEmptyTitle => 'No data yet';

  @override
  String get reportsEmptySubtitle => 'Start sessions to populate this report.';

  @override
  String get upgraderRequiredTitle => 'Update Required';

  @override
  String get upgraderRecommendedTitle => 'Update Available';

  @override
  String get upgraderRequiredDescription => 'This version is no longer supported. Please update the app to continue.';

  @override
  String get upgraderRecommendedDescription => 'A new version is available. Update for the best experience.';

  @override
  String get upgraderUpdateButton => 'Update';

  @override
  String get upgraderLaterButton => 'Later';

  @override
  String get currencyLabel => 'som';

  @override
  String get profileProductsTitle => 'Products and prices';

  @override
  String get profileProductsSubtitle => 'Drinks, food, rent';

  @override
  String get productsTitle => 'Products and prices';

  @override
  String get productsFilterAll => 'All';

  @override
  String get productsAddButton => 'Add product';

  @override
  String get productsCreateTitle => 'New product';

  @override
  String get productsEditTitle => 'Edit product';

  @override
  String get productsCreateButton => 'Create product';

  @override
  String get productsUpdateButton => 'Update';

  @override
  String get productsEmptyTitle => 'No products yet';

  @override
  String get productsEmptySubtitle => 'Add your first product to start selling.';

  @override
  String productsDeleteTitle(String name) {
    return 'Delete \"$name\"?';
  }

  @override
  String get productsDeleteSubtitle => 'This product will be soft-deleted and won\'t appear in active sessions.';

  @override
  String get productsNameLabel => 'Name';

  @override
  String get productsNameHint => 'e.g. Water 0.5L';

  @override
  String get productsPriceLabel => 'Price';

  @override
  String get productsPriceHint => 'e.g. 50';

  @override
  String get productsPriceInvalid => 'Enter a valid price greater than 0';

  @override
  String get productsCategoryLabel => 'Category';

  @override
  String get productsUnitLabel => 'Unit';

  @override
  String get productsDescriptionLabel => 'Description (optional)';

  @override
  String get productsDescriptionHint => 'Short description...';

  @override
  String get productsPhotoSectionLabel => 'Photo (optional)';

  @override
  String get productsIconPickerLabel => 'Or choose an icon:';

  @override
  String get productsPhotoPickerLabel => 'Add';

  @override
  String get productCategoryDrink => 'Drinks';

  @override
  String get productCategoryFood => 'Food';

  @override
  String get productCategoryEquipment => 'Rental';

  @override
  String get productCategoryOther => 'Other';

  @override
  String get productUnitPiece => 'Piece';

  @override
  String get productUnitKg => 'kg';

  @override
  String get productUnitLitre => 'Litre';

  @override
  String get productUnitPortion => 'Portion';

  @override
  String get productUnitHour => 'Hour';

  @override
  String get productUnitPieceShort => 'pcs';

  @override
  String get productUnitKgShort => 'kg';

  @override
  String get productUnitLitreShort => 'L';

  @override
  String get productUnitPortionShort => 'port.';

  @override
  String get productUnitHourShort => 'hr';

  @override
  String get reportsTopProductsTitle => 'Top products';

  @override
  String get reportsProductsTitle => 'Products';

  @override
  String get reportsSeeAll => 'See all';

  @override
  String get reportsProductDetailTitle => 'Product sales';

  @override
  String get reportsProductSoldLabel => 'SOLD';

  @override
  String get reportsProductRevenueLabel => 'REVENUE';

  @override
  String reportsProductCurrentPrice(String price) {
    return 'Current price: $price / pc';
  }

  @override
  String get reportsProductSalesLogTitle => 'Sales log';

  @override
  String reportsProductPriceAtTime(String old, String current) {
    return 'Then: $old · now: $current';
  }

  @override
  String get productDeletedBadge => 'This product has been deleted';

  @override
  String get reportsProductPriceHistoryTitle => 'Price history';

  @override
  String reportsProductPriceHistorySubtitle(int count) {
    return 'Sold at $count different prices';
  }

  @override
  String get reportsProductPriceNowBadge => 'NOW';

  @override
  String sessionOrderSection(int count) {
    return 'ORDER · $count';
  }

  @override
  String get sessionOrderSectionLabel => 'ORDER';

  @override
  String get sessionOrderEmpty => 'Guests asked for water or a snack? Add it — the amount will go to the final bill.';

  @override
  String get sessionAddProduct => 'Add product';

  @override
  String get sessionRemoveProductTitle => 'Remove from order?';

  @override
  String get sessionRemoveProductSubtitle => 'This item will be removed from the order.';

  @override
  String get sessionRemoveProductConfirm => 'Remove';

  @override
  String get spotDetailGameTime => 'Game time';

  @override
  String get spotDetailProductsTotal => 'Products';

  @override
  String get addProductSheetTitle => 'Add product';

  @override
  String get addProductQuantityLabel => 'QUANTITY';

  @override
  String get addProductTotalLabel => 'TOTAL';

  @override
  String get addProductConfirm => 'Confirm';

  @override
  String paymentProductsSection(int count) {
    return 'PRODUCTS · $count';
  }

  @override
  String get paymentProductsTotal => 'Products total';

  @override
  String get paymentSubtotalLine => 'Subtotal';
}
