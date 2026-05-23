// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Kirghiz Kyrgyz (`ky`).
class AppLocalizationsKy extends AppLocalizations {
  AppLocalizationsKy([String locale = 'ky']) : super(locale);

  @override
  String get homeWelcomeBack => 'Кайра кош келиңиз';

  @override
  String get settingsTitle => 'Жөндөөлөр';

  @override
  String get settingsAppearance => 'Көрүнүш';

  @override
  String get settingsThemeMode => 'Тема';

  @override
  String get settingsThemePickerTitle => 'Теманы тандаңыз';

  @override
  String get settingsLanguage => 'Тил';

  @override
  String get settingsLanguagePickerTitle => 'Тилди тандаңыз';

  @override
  String get settingsThemeLight => 'Жарык';

  @override
  String get settingsThemeDark => 'Караңгы';

  @override
  String get settingsThemeSystem => 'Система';

  @override
  String get authTagline => 'Залды санариптик башкаруу';

  @override
  String get authSignIn => 'Кирүү';

  @override
  String get authSignUp => 'Катталуу';

  @override
  String get authSignInSubtitle => 'Кирүү маалыматыңызды жазыңыз';

  @override
  String get authUsernameOrEmail => 'Логин же email';

  @override
  String get authPassword => 'Сырсөз';

  @override
  String get authForgotPassword => 'Сырсөздү унуттуңузбу?';

  @override
  String get authNoAccount => 'Аккаунт жокпу?';

  @override
  String get authChooseRole => 'Сиз кимсиз?';

  @override
  String get authChooseRoleSubtitle => 'Бул жеткиликтүү функцияларды аныктайт';

  @override
  String get authOwnerTitle => 'Зал ээси';

  @override
  String get authOwnerSubtitle => 'Бир же бирнече залды башкарам';

  @override
  String get authManagerTitle => 'Зал менеджери';

  @override
  String get authManagerSubtitle => 'Кезмеде иштейм, чакыруу коду керек';

  @override
  String get authRegisterOwnerTitle => 'Ээнин каттоосу';

  @override
  String get authRegisterManagerTitle => 'Менеджердин каттоосу';

  @override
  String get authOwnerBadge => 'Ээ';

  @override
  String get authManagerBadge => 'Менеджер';

  @override
  String get authNameLabel => 'Аты';

  @override
  String get authPhoneLabel => 'Телефон';

  @override
  String get authEmailLabel => 'Email';

  @override
  String get authInviteCodeLabel => 'Чакыруу коду';

  @override
  String get authUsernameLabel => 'Логин';

  @override
  String get authConfirmPasswordLabel => 'Сырсөздү кайталаңыз';

  @override
  String get authVenueNameLabel => 'Жайдын аты';

  @override
  String get authVenueNumberLabel => 'Жайдын номери';

  @override
  String get authAgreeTerms => 'Шарттарга макулмун';

  @override
  String get authAgreeTermsError => 'Шарттарга макул болушуңуз керек';

  @override
  String get authCreateAccount => 'Аккаунт түзүү';

  @override
  String get authInviteCodeHint => 'Чакыруу кодун зал ээсинен алыңыз';

  @override
  String get authFieldRequired => 'Талаа милдеттүү түрдө толтурулушу керек';

  @override
  String get authPasswordMinLength => 'Сырсөз кеминде 8 символдон турушу керек';

  @override
  String get authPasswordsDoNotMatch => 'Сырсөздөр дал келбейт';

  @override
  String get authInvalidEmail => 'Туура email жазыңыз';

  @override
  String get authInvalidPhone => 'Туура телефон номерин жазыңыз';

  @override
  String get authForgotPasswordTitle => 'Сырсөздү калыбына келтирүү';

  @override
  String get authForgotPasswordBanner => 'Логин же email\'иңизди жазыңыз — сырсөздү жаңыртуу үчүн шилтеме жөнөтөбүз.';

  @override
  String get authForgotPasswordLoginEmailPlaceholder => 'мисалы, azamat@mail.kg';

  @override
  String get authForgotPasswordNoLink => 'Шилтеме келбей жатабы?';

  @override
  String get authForgotPasswordContactUs => 'Биз менен байланышыңыз — WhatsApp, Telegram, email, чалуу';

  @override
  String get authForgotPasswordSendLink => 'Шилтеме жөнөтүү';

  @override
  String get contactSupportTitle => 'Колдоо кызматы менен байланышуу';

  @override
  String get contactSupportSubtitle => 'Жазыңыз же чалыңыз — биз жардамдашабыз.';

  @override
  String get contactCallLabel => 'Чалуу';

  @override
  String get navHome => 'Башкы';

  @override
  String get navReport => 'Отчеттор';

  @override
  String get navProfile => 'Профиль';

  @override
  String get homeCreateVenue => 'Зал түзүү';

  @override
  String get homeNoVenuesTitle => 'Азырынча залдарыңыз жок';

  @override
  String get homeNoVenuesSubtitle => 'Позицияларды кошуп, сессияларды кабыл алуу үчүн биринчи залыңызды түзүңүз.';

  @override
  String get homeSelectVenue => 'Зал тандоо';

  @override
  String get homeNewVenue => 'Жаңы зал';

  @override
  String homeAddSpot(String spot) {
    return '$spot кошуу';
  }

  @override
  String homeSpotsEmpty(String spotPlural) {
    return 'Азырынча $spotPlural жок';
  }

  @override
  String homeSpotsEmptySub(String spot) {
    return 'Менеджерлер сессия баштай алышы үчүн биринчи $spot кошуңуз.';
  }

  @override
  String homeSpotsEmptySubManager(String spotPlural) {
    return '$spotPlural ээси кошкондон кийин пайда болот.';
  }

  @override
  String homeSpotOccupied(String customerName) {
    return '$customerName · БОШ ЭМЕС';
  }

  @override
  String get homeSpotOccupiedBase => 'БОШ ЭМЕС';

  @override
  String homeSpotPaused(String customerName) {
    return '$customerName · ТОКТОТУЛДУ';
  }

  @override
  String get homeSpotPausedBase => 'ТОКТОТУЛДУ';

  @override
  String get homeSpotFree => 'БОШ';

  @override
  String get homeSpotJustFreed => '✓ Аяктады';

  @override
  String get createSpotTitle => 'Жаңы позиция';

  @override
  String get createSpotNumberLabel => 'Позиция номери';

  @override
  String get createSpotNumberHint => '1';

  @override
  String get createSpotNameLabel => 'Позиция аты';

  @override
  String get createSpotNameHint => 'Позиция 1';

  @override
  String get createSpotDescLabel => 'Сыпаттама (белги)';

  @override
  String get createSpotDescHint => 'VIP зал, терезенин жанында, снукер...';

  @override
  String get createSpotDescPlaceholder => 'Сыпаттама';

  @override
  String get createSpotRateLabel => 'Тариф';

  @override
  String createSpotRateSuffix(String currency, String time_unit) {
    return '$currency/$time_unit';
  }

  @override
  String get createSpotButton => 'Позиция түзүү';

  @override
  String get editSpotTitle => 'Позицияны өзгөртүү';

  @override
  String get updateSpotButton => 'Жаңыртуу';

  @override
  String get deleteSpotButton => 'Жок кылуу';

  @override
  String get deleteSpotSubtitle => 'Сессиялардын тарыхы сакталат, бирок позиция башкы баракчадан жоголот.';

  @override
  String get createVenueTitle => 'Залды түзүңүз';

  @override
  String get createVenueSubtitle => 'Залыңызга ат бериңиз. Позицияларды кийинчерек башкы баракчадан кошсо болот.';

  @override
  String get createVenueNameLabel => 'Зал аты';

  @override
  String get createVenueNameHint => 'Борбордук филиал';

  @override
  String get createVenueNumberLabel => 'Кыска код / номер (милдеттүү эмес)';

  @override
  String get createVenueNumberHint => '№ 1 же БФ';

  @override
  String get createVenueInfoBanner => 'Зал түзүлгөндөн кийин позицияларды бирден өз тарифи менен кошо аласыз.';

  @override
  String get createVenueButton => 'Зал түзүү →';

  @override
  String get editVenueTitle => 'Залды өзгөртүү';

  @override
  String get updateVenueButton => 'Жаңыртуу';

  @override
  String get deleteVenueButton => 'Жок кылуу';

  @override
  String get deleteVenueSubtitle => 'Бардык позициялар жана сессиялардын тарыхы сакталат, бирок зал жок кылынат.';

  @override
  String get cancel => 'Жокко чыгаруу';

  @override
  String get generalRetry => 'Кайталоо';

  @override
  String get createSpotTarifTypeLabel => 'Тариф түрү';

  @override
  String get tarifTypeMinute => 'Мүнөт';

  @override
  String get tarifTypeHour => 'Саат';

  @override
  String get tarifTypeDay => 'Күн';

  @override
  String get createSpotCurrencyLabel => 'Валюта';

  @override
  String get currencyKgs => 'Сом';

  @override
  String get currencyUsd => 'Доллар';

  @override
  String get currencyRub => 'Рубль';

  @override
  String get currencyKzt => 'Теңге';

  @override
  String get currencyTry => 'Лира';

  @override
  String venueSpotsCount(int count, String spot, String spotPlural) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count $spot',
      zero: '$spotPlural жок',
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
  String get profileSectionManagement => 'Башкаруу';

  @override
  String get profileManageVenuesTitle => 'Залдарды башкаруу';

  @override
  String profileManageVenuesSubtitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count зал',
      zero: 'зал жок',
    );
    return '$_temp0';
  }

  @override
  String get profileManagersTitle => 'Менеджерлер';

  @override
  String profileManagersSubtitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count менеджер',
      zero: 'менеджер жок',
    );
    return '$_temp0';
  }

  @override
  String get profileSectionAccount => 'Аккаунт';

  @override
  String get profileSubscriptionTitle => 'Жазылуу';

  @override
  String profileSubscriptionActiveUntil(String date) {
    return 'Активдүү · $date чейин';
  }

  @override
  String get profileChangePasswordTitle => 'Сырсөздү өзгөртүү';

  @override
  String get profileSettingsTitle => 'Жөндөөлөр';

  @override
  String get profileSettingsSubtitle => 'Тема, тил';

  @override
  String get authUpdatePasswordTitle => 'Сырсөздү өзгөртүү';

  @override
  String get authUpdatePasswordHint => 'Минимум 8 символ. Тамгаларды, сандарды жана атайын символдорду колдонуңуз.';

  @override
  String get authUpdatePasswordLoginLabel => 'Логин / Email';

  @override
  String get authUpdatePasswordNewLabel => 'Жаңы сырсөз';

  @override
  String get authUpdatePasswordRepeatLabel => 'Жаңы сырсөздү кайталаңыз';

  @override
  String get authUpdatePasswordSubmit => 'Сактоо';

  @override
  String get authUpdatePasswordSuccess => 'Сырсөз жаңыртылды';

  @override
  String get profileLogout => 'Чыгуу';

  @override
  String get profileLogoutTitle => 'Аккаунттан чыгасызбы?';

  @override
  String get profileLogoutSubtitle => 'Сиз кирүү экранына багытталасыз. Маалыматтар сакталат.';

  @override
  String get profileDeleteAccount => 'Аккаунтту өчүрүү';

  @override
  String get profileDeleteAccountTitle => 'Аккаунтту өчүрөсүзбү?';

  @override
  String get profileDeleteAccountSubtitle =>
      'Бардык маалыматтар, сессиялар жана жөндөөлөр биротоло өчүрүлөт. Бул аракетти артка кайтаруу мүмкүн эмес.';

  @override
  String get profileDeleteAccountConfirm => 'Биротоло өчүрүү';

  @override
  String get profileErrorTitle => 'Профилди жүктөө мүмкүн болбоду';

  @override
  String get profileErrorSubtitle => 'Туташууну текшерип, кайра аракет кылыңыз.';

  @override
  String get sessionCustomerName => 'Кардардын аты (милдеттүү эмес)';

  @override
  String get sessionCustomerNameHint => 'мис. Иван Иванов';

  @override
  String get spotDetailStart => 'БАШТОО';

  @override
  String get spotDetailStop => 'ТОКТОТУУ ЖАНА ЖАБУУ';

  @override
  String get spotDetailElapsed => 'ӨТКӨН';

  @override
  String get spotDetailCurrentAmount => 'УЧУРДАГЫ СУММА';

  @override
  String get spotDetailPause => 'ТЫНЫГУУ';

  @override
  String get spotDetailResume => 'УЛАНТУУ';

  @override
  String get spotDetailStartTime => 'Башталышы';

  @override
  String get spotDetailDuration => 'Узактыгы';

  @override
  String get spotDetailTariff => 'Тариф';

  @override
  String get spotDetailMistakeLaunch => 'Ката иш-аракет';

  @override
  String get spotDetailMistakeLaunchTitle => 'Сессияны жокко чыгаруу?';

  @override
  String get spotDetailMistakeLaunchSubtitle => 'Сессия төлөмсүз жокко чыгарылат.';

  @override
  String get spotDetailMistakeLaunchConfirm => 'Ооба, жокко чыгаруу';

  @override
  String get spotDetailLastSession => 'Акыркы сессия';

  @override
  String get spotDetailTodaySessions => 'Бүгүнкү сессиялар';

  @override
  String get spotDetailPaymentTitle => 'Төлөм корутундусу';

  @override
  String get spotDetailSubtotal => 'Аралык жыйынтык';

  @override
  String get spotDetailDiscount => 'Арзандатуу';

  @override
  String get spotDetailToPay => 'ТӨЛӨНҮҮГӨ';

  @override
  String get spotDetailConfirmAndClose => 'ЫРАСТОО ЖАНА ЖАБУУ';

  @override
  String spotDetailDurationMin(int count) {
    return '$count мин';
  }

  @override
  String get spotLabelSpot => 'Үстөл';

  @override
  String get spotLabelConsole => 'Консоль';

  @override
  String get spotLabelCourt => 'Аянтча';

  @override
  String get spotLabelBoard => 'Тактай';

  @override
  String get spotLabelPitch => 'Талаа';

  @override
  String get spotLabelSpotPlural => 'Үстөлдөр';

  @override
  String get spotLabelConsolePlural => 'Консолдор';

  @override
  String get spotLabelCourtPlural => 'Аянтчалар';

  @override
  String get spotLabelBoardPlural => 'Тактайлар';

  @override
  String get spotLabelPitchPlural => 'Талаалар';

  @override
  String get venueTypeSpotTennis => 'Үстөл теннис';

  @override
  String get venueTypeBilliards => 'Бильярд';

  @override
  String get venueTypePlayStation => 'PlayStation';

  @override
  String get venueTypeVolleyball => 'Волейбол';

  @override
  String get venueTypeBasketball => 'Баскетбол';

  @override
  String get venueTypeChess => 'Шахмат';

  @override
  String get venueTypeFootball => 'Футбол';

  @override
  String get venueFormTypeLabel => 'Тип';

  @override
  String get venueFormTypeImmutableHint => 'Тип түзүлгөндөн кийин өзгөртүлбөйт. Спорт түрү өзгөрсө, жаңы зал түзүңүз.';

  @override
  String get venueFormTypeRequiredError => 'Залдын типин тандаңыз';

  @override
  String get menuEdit => 'Өзгөртүү';

  @override
  String get menuDelete => 'Жок кылуу';

  @override
  String get managersInviteCodeLabel => 'АКТИВДҮҮ ЧАКЫРУУ КОДУ';

  @override
  String get managersInviteCodeErrorLabel => 'ЧАКЫРУУ КОДУ ЖЕТКИЛИКСИЗ';

  @override
  String get managersInviteCodeCopy => 'Көчүрүү';

  @override
  String get managersInviteCodeCopied => 'Код көчүрүлдү';

  @override
  String get managersSectionLabel => 'МЕНЕДЖЕРЛЕР';

  @override
  String get managersInviteAction => 'Менеджер чакыруу';

  @override
  String managersDeleteTitle(String name) {
    return '$name чыгарылсынбы?';
  }

  @override
  String get managersDeleteSubtitle =>
      'Менеджер сиздин залдарга кирүү мүмкүндүгүн жоготот. Анын сессияларынын тарыхы сакталат.';

  @override
  String get managersEmptyTitle => 'Азырынча менеджер жок';

  @override
  String get managersEmptySubtitle => 'Чакыруу кодун бөлүшүңүз — менеджер катталып, кезмеге чыга алат.';

  @override
  String get managersLastSeenJustNow => 'онлайн';

  @override
  String managersLastSeenMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count мүн мурун',
      one: '1 мүн мурун',
    );
    return '$_temp0';
  }

  @override
  String managersLastSeenHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count саат мурун',
      one: '1 саат мурун',
    );
    return '$_temp0';
  }

  @override
  String managersLastSeenDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count күн мурун',
      one: '1 күн мурун',
    );
    return '$_temp0';
  }

  @override
  String venueSpotsCountSuffix(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count даана',
      zero: '0 даана',
    );
    return '$_temp0';
  }

  @override
  String get subscriptionTitle => 'Жазылуу';

  @override
  String get subscriptionStatusActive => 'Активдүү';

  @override
  String get subscriptionStatusGrace => 'Жеңилдик мөөнөтү';

  @override
  String get subscriptionStatusExpired => 'Бүткөн';

  @override
  String get subscriptionSourceTrial => 'Сыноо мөөнөтү';

  @override
  String get subscriptionSourcePaid => 'Төлөнгөн';

  @override
  String subscriptionWarningBanner(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'Жазылууңуздун $n күнү калды. Үзгүлтүксүздүк үчүн узартыңыз.',
      one: 'Жазылууңуздун 1 күнү калды. Үзгүлтүксүздүк үчүн узартыңыз.',
    );
    return '$_temp0';
  }

  @override
  String subscriptionGraceBanner(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'Жазылуу бүттү. Жеңилдик мөөнөтүнүн $n күнү калды.',
      one: 'Жазылуу бүттү. Жеңилдик мөөнөтүнүн 1 күнү калды.',
    );
    return '$_temp0';
  }

  @override
  String get subscriptionExpiredBanner => 'Жазылуу бүттү. Негизги функцияларды колдонуу үчүн узартыңыз.';

  @override
  String subscriptionPlanCardPerSpot(int price, String currency) {
    return '$price $currency / позиция / ай';
  }

  @override
  String subscriptionPlanCardMonthly(int tableCount, int monthly, String currency) {
    return '× $tableCount позиция = $monthly $currency / ай';
  }

  @override
  String get subscriptionDetailNextPayment => 'Кийинки төлөм';

  @override
  String get subscriptionDetailLastPayment => 'Акыркы төлөм';

  @override
  String get subscriptionDetailStatus => 'Статус';

  @override
  String get subscriptionPaymentHistoryTitle => 'Төлөм тарыхы';

  @override
  String get subscriptionPaymentHistoryEmpty => 'Төлөм али жок';

  @override
  String subscriptionPaymentItemSummary(int months, int tableCount) {
    return '$months ай × $tableCount позиция';
  }

  @override
  String subscriptionAmountWithCurrency(int amount, String currency) {
    return '$amount $currency';
  }

  @override
  String get subscriptionContinueCta => 'Жазылууну улантуу';

  @override
  String get subscriptionCheckoutTitle => 'Төлөө';

  @override
  String subscriptionCheckoutSummary(int tableCount, int price, int monthly, String currency) {
    return '$tableCount позиция × $price $currency = $monthly $currency / ай';
  }

  @override
  String get subscriptionCheckoutDuration => 'Узактык';

  @override
  String subscriptionCheckoutMonthsLabel(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n ай',
      one: '1 ай',
    );
    return '$_temp0';
  }

  @override
  String get subscriptionCheckoutTotal => 'Жалпы';

  @override
  String subscriptionCheckoutTotalLine(int months, int monthly, int total, String currency) {
    return '$months ай × $monthly $currency = $total $currency';
  }

  @override
  String subscriptionCheckoutNewEndDate(String date) {
    return 'Жаңы бүтүү күнү: $date';
  }

  @override
  String get subscriptionCheckoutPay => 'Төлөө';

  @override
  String get subscriptionCheckoutNoSpotsTitle => 'Позиция али жок';

  @override
  String get subscriptionCheckoutNoSpotsSubtitle => 'Жазылуу үчүн жок дегенде бир позиция кошуңуз.';

  @override
  String get subscriptionCheckoutGoToVenues => 'Залдарга өтүү';

  @override
  String get subscriptionPaymentMockTitle => 'Тесттик төлөм';

  @override
  String get subscriptionPaymentMockSubtitle =>
      'Чыныгы төлөм интеграциясы жакында. Натыйжаны төмөндө симуляция кылыңыз.';

  @override
  String get subscriptionPaymentSimulateSuccess => 'Ийгиликти симуляция кылуу';

  @override
  String get subscriptionPaymentSimulateFailure => 'Катаны симуляция кылуу';

  @override
  String get subscriptionPaymentSuccessTitle => 'Төлөм ийгиликтүү';

  @override
  String subscriptionPaymentSuccessBody(String date) {
    return 'Жазылуу $date чейин узартылды.';
  }

  @override
  String get subscriptionPaymentFailedTitle => 'Төлөм ишке ашпады';

  @override
  String get subscriptionPaymentFailedBody => 'Бир нерсе туура эмес болду. Кайра аракет кылыңыз.';

  @override
  String get subscriptionPaymentRetry => 'Кайра аракет кылуу';

  @override
  String get subscriptionPaymentClose => 'Жабуу';

  @override
  String get subscriptionBlockedTitle => 'Жазылуу керек';

  @override
  String get subscriptionBlockedSubtitle => 'Негизги функцияларды колдонуу үчүн жазылууну узартыңыз.';

  @override
  String get subscriptionBlockedRenew => 'Узартуу';

  @override
  String get subscriptionBlockedCancel => 'Азыр эмес';

  @override
  String get subscriptionErrorTitle => 'Жазылууну жүктөө мүмкүн болбоду';

  @override
  String get subscriptionErrorSubtitle => 'Туташууну текшерип, кайра аракет кылыңыз.';

  @override
  String get subscriptionContactSupportAction => 'Жардам керекпи? Колдоо менен байланышыңыз';

  @override
  String profileSubscriptionExpiresIn(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n күндө бүтөт',
      one: '1 күндө бүтөт',
    );
    return '$_temp0';
  }

  @override
  String profileSubscriptionGrace(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'Жеңилдик · $n күн калды',
      one: 'Жеңилдик · 1 күн калды',
    );
    return '$_temp0';
  }

  @override
  String get profileSubscriptionExpired => 'Бүттү';

  @override
  String get reportsOverviewTitle => 'Отчёттор';

  @override
  String get reportsManagerDetailTitle => 'Менеджер';

  @override
  String get reportsSpotDetailTitle => 'Позиция';

  @override
  String get reportsPeriodToday => 'Бүгүн';

  @override
  String get reportsPeriodWeek => 'Жума';

  @override
  String get reportsPeriodMonth => 'Ай';

  @override
  String get reportsPeriodYear => 'Жыл';

  @override
  String get reportsPeriodCustom => 'Мөөнөт';

  @override
  String get reportsVenuePickerTitle => 'Залды тандаңыз';

  @override
  String get reportsKpiRevenue => 'Жалпы киреше';

  @override
  String get reportsKpiSessions => 'Сессиялар';

  @override
  String get reportsRevenueChartTitle => 'Күн боюнча киреше';

  @override
  String get reportsRevenueChartCompareToggle => 'Мурунку мөөнөт менен салыштыруу';

  @override
  String get reportsTopManagersTitle => 'Менеджерлер';

  @override
  String get reportsSpotLabel => 'Позиция';

  @override
  String get reportsSessionsShort => 'сессия';

  @override
  String get reportsCancelledShort => 'жокко чыгаруу';

  @override
  String get reportsSessionLogTitle => 'Сессия логу';

  @override
  String get reportsLogFilterAll => 'Баары';

  @override
  String get reportsLogFilterCancelled => 'Жокко чыгарылган';

  @override
  String get reportsLogStatusActive => 'Процессте';

  @override
  String get reportsLogEmpty => 'Бул фильтрде сессия жок.';

  @override
  String get reportsForecastSummaryTitle => 'Болжом';

  @override
  String get reportsForecastVsPrevious => 'мурунку мөөнөт менен';

  @override
  String reportsForecastVsRange(String previous) {
    return '$previous менен';
  }

  @override
  String get reportsForecastNoComparison => 'Тарых али жетишсиз';

  @override
  String reportsComparisonCaption(String current, String previous) {
    return '$current  ·  vs $previous';
  }

  @override
  String get reportsSpotTrendTitle => 'Киреше трендине';

  @override
  String get reportsSpotHeatmapTitle => 'Саат боюнча карта';

  @override
  String get reportsErrorTitle => 'Отчётту жүктөө мүмкүн эмес';

  @override
  String get reportsEmptyTitle => 'Маалымат али жок';

  @override
  String get reportsEmptySubtitle => 'Сессияларды баштап, бул жерди толтуруңуз.';

  @override
  String get upgraderRequiredTitle => 'Жаңыртуу талап кылынат';

  @override
  String get upgraderRecommendedTitle => 'Жаңыртуу жеткиликтүү';

  @override
  String get upgraderRequiredDescription => 'Бул версия колдоого алынбайт. Улантуу үчүн колдонмону жаңыртыңыз.';

  @override
  String get upgraderRecommendedDescription => 'Жаңы версия жеткиликтүү. Мыкты тажрыйба үчүн жаңыртыңыз.';

  @override
  String get upgraderUpdateButton => 'Жаңыртуу';

  @override
  String get upgraderLaterButton => 'Кийинчерээк';

  @override
  String get currencyLabel => 'сом';

  @override
  String get profileProductsTitle => 'Товарлар жана баалар';

  @override
  String get profileProductsSubtitle => 'Суусундуктар, тамак-аш, аренда';

  @override
  String get productsTitle => 'Товарлар жана баалар';

  @override
  String get productsFilterAll => 'Баары';

  @override
  String get productsAddButton => 'Товар кошуу';

  @override
  String get productsCreateTitle => 'Жаңы товар';

  @override
  String get productsEditTitle => 'Товарды түзөтүү';

  @override
  String get productsCreateButton => 'Товар түзүү';

  @override
  String get productsUpdateButton => 'Жаңыртуу';

  @override
  String get productsEmptyTitle => 'Товарлар жок';

  @override
  String get productsEmptySubtitle => 'Сатуу баштоо үчүн биринчи товарды кошуңуз.';

  @override
  String productsDeleteTitle(String name) {
    return '\"$name\" жок кылуу?';
  }

  @override
  String get productsDeleteSubtitle => 'Товар жашырылат жана активдүү сессияларда көрүнбөйт.';

  @override
  String get productsNameLabel => 'Аталышы';

  @override
  String get productsNameHint => 'мис. Суу 0.5л';

  @override
  String get productsPriceLabel => 'Баасы';

  @override
  String get productsPriceHint => 'мис. 50';

  @override
  String get productsPriceInvalid => '0дон чоң туура баа киргизиңиз';

  @override
  String get productsCategoryLabel => 'Категория';

  @override
  String get productsUnitLabel => 'Өлчөм бирдиги';

  @override
  String get productsDescriptionLabel => 'Сүрөттөмө (милдеттүү эмес)';

  @override
  String get productsDescriptionHint => 'Кыскача сүрөттөмө...';

  @override
  String get productsPhotoSectionLabel => 'Сүрөт (кошумча)';

  @override
  String get productsIconPickerLabel => 'Же иконка тандаңыз:';

  @override
  String get productsPhotoPickerLabel => 'Кошуу';

  @override
  String get productCategoryDrink => 'Суусундуктар';

  @override
  String get productCategoryFood => 'Тамак-аш';

  @override
  String get productCategoryEquipment => 'Аренда';

  @override
  String get productCategoryOther => 'Башка';

  @override
  String get productUnitPiece => 'Штука';

  @override
  String get productUnitKg => 'кг';

  @override
  String get productUnitLitre => 'Литр';

  @override
  String get productUnitPortion => 'Порция';

  @override
  String get productUnitHour => 'Саат';

  @override
  String get productUnitPieceShort => 'шт';

  @override
  String get productUnitKgShort => 'кг';

  @override
  String get productUnitLitreShort => 'л';

  @override
  String get productUnitPortionShort => 'порц.';

  @override
  String get productUnitHourShort => 'саат';

  @override
  String get reportsTopProductsTitle => 'Жогорку товарлар';

  @override
  String get reportsProductsTitle => 'Товарлар';

  @override
  String get reportsSeeAll => 'Баарын кёр';

  @override
  String get reportsProductDetailTitle => 'Товар сатуулары';

  @override
  String get reportsProductSoldLabel => 'САТЫЛГАН';

  @override
  String get reportsProductRevenueLabel => 'ТҮШҮМ';

  @override
  String reportsProductCurrentPrice(String price) {
    return 'Учурдагы баасы: $price / шт';
  }

  @override
  String get reportsProductSalesLogTitle => 'Сатуу журналы';

  @override
  String reportsProductPriceAtTime(String old, String current) {
    return 'Ошондо: $old · азыр: $current';
  }

  @override
  String get productDeletedBadge => 'Бул товар жоюлган';

  @override
  String get reportsProductPriceHistoryTitle => 'Баалар тарыхы';

  @override
  String reportsProductPriceHistorySubtitle(int count) {
    return '$count башка баада сатылган';
  }

  @override
  String get reportsProductPriceNowBadge => 'АЗЫР';
}
