// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get homeWelcomeBack => 'С возвращением';

  @override
  String get settingsTitle => 'Настройки';

  @override
  String get settingsAppearance => 'Внешний вид';

  @override
  String get settingsThemeMode => 'Тема';

  @override
  String get settingsThemePickerTitle => 'Выберите тему';

  @override
  String get settingsLanguage => 'Язык';

  @override
  String get settingsLanguagePickerTitle => 'Выберите язык';

  @override
  String get settingsThemeLight => 'Светлая';

  @override
  String get settingsThemeDark => 'Тёмная';

  @override
  String get settingsThemeSystem => 'Системная';

  @override
  String get authTagline => 'Цифровое управление залом';

  @override
  String get authSignIn => 'Войти';

  @override
  String get authSignUp => 'Регистрация';

  @override
  String get authSignInSubtitle => 'Введите ваши данные';

  @override
  String get authUsernameOrEmail => 'Логин или email';

  @override
  String get authPassword => 'Пароль';

  @override
  String get authForgotPassword => 'Забыли пароль?';

  @override
  String get authNoAccount => 'Нет аккаунта?';

  @override
  String get authChooseRole => 'Кто вы?';

  @override
  String get authChooseRoleSubtitle => 'От этого зависят доступные функции';

  @override
  String get authOwnerTitle => 'Владелец зала';

  @override
  String get authOwnerSubtitle => 'Я управляю одним или несколькими залами';

  @override
  String get authManagerTitle => 'Менеджер зала';

  @override
  String get authManagerSubtitle => 'Я работаю по сменам, нужен код приглашения';

  @override
  String get authRegisterOwnerTitle => 'Регистрация владельца';

  @override
  String get authRegisterManagerTitle => 'Регистрация менеджера';

  @override
  String get authOwnerBadge => 'Владелец';

  @override
  String get authManagerBadge => 'Менеджер';

  @override
  String get authNameLabel => 'Имя';

  @override
  String get authPhoneLabel => 'Телефон';

  @override
  String get authEmailLabel => 'Email';

  @override
  String get authInviteCodeLabel => 'Код приглашения';

  @override
  String get authUsernameLabel => 'Логин';

  @override
  String get authConfirmPasswordLabel => 'Подтвердите пароль';

  @override
  String get authVenueNameLabel => 'Название зала';

  @override
  String get authVenueNumberLabel => 'Номер зала';

  @override
  String get authAgreeTerms => 'Я согласен с условиями';

  @override
  String get authAgreeTermsError => 'Вы должны согласиться с условиями';

  @override
  String get authCreateAccount => 'Создать аккаунт';

  @override
  String get authInviteCodeHint => 'Получите код приглашения у владельца зала';

  @override
  String get authFieldRequired => 'Поле обязательно для заполнения';

  @override
  String get authPasswordMinLength => 'Пароль должен содержать минимум 8 символов';

  @override
  String get authPasswordsDoNotMatch => 'Пароли не совпадают';

  @override
  String get authInvalidEmail => 'Введите корректный email';

  @override
  String get authInvalidPhone => 'Введите корректный номер телефона';

  @override
  String get authForgotPasswordTitle => 'Восстановление пароля';

  @override
  String get authForgotPasswordBanner => 'Введите ваш логин или email — мы отправим ссылку для сброса пароля.';

  @override
  String get authForgotPasswordLoginEmailPlaceholder => 'напр., azamat@mail.kg';

  @override
  String get authForgotPasswordNoLink => 'Ссылка не приходит?';

  @override
  String get authForgotPasswordContactUs => 'Свяжитесь с нами — WhatsApp, Telegram, email, звонок';

  @override
  String get authForgotPasswordSendLink => 'Отправить ссылку';

  @override
  String get contactSupportTitle => 'Связаться с поддержкой';

  @override
  String get contactSupportSubtitle => 'Напишите или позвоните — мы поможем.';

  @override
  String get contactCallLabel => 'Позвонить';

  @override
  String get navHome => 'Главная';

  @override
  String get navReport => 'Отчёты';

  @override
  String get navProfile => 'Профиль';

  @override
  String get homeCreateVenue => 'Создать зал';

  @override
  String get homeNoVenuesTitle => 'У вас пока нет залов';

  @override
  String get homeNoVenuesSubtitle => 'Создайте первый зал, чтобы начать добавлять позиции и принимать сессии.';

  @override
  String get homeSelectVenue => 'Выберите зал';

  @override
  String get homeNewVenue => 'Новый зал';

  @override
  String homeAddSpot(String spot) {
    return 'Добавить $spot';
  }

  @override
  String homeSpotsEmpty(String spotPlural) {
    return '$spotPlural пока нет';
  }

  @override
  String homeSpotsEmptySub(String spot) {
    return 'Добавьте первую позицию ($spot), чтобы менеджеры могли начинать сессии.';
  }

  @override
  String homeSpotsEmptySubManager(String spotPlural) {
    return '$spotPlural появятся здесь, как только их добавит владелец.';
  }

  @override
  String homeSpotOccupied(String customerName) {
    return '$customerName · ЗАНЯТ';
  }

  @override
  String get homeSpotOccupiedBase => 'ЗАНЯТ';

  @override
  String homeSpotPaused(String customerName) {
    return '$customerName · НА ПАУЗЕ';
  }

  @override
  String get homeSpotPausedBase => 'НА ПАУЗЕ';

  @override
  String get homeSpotFree => 'СВОБОДЕН';

  @override
  String get homeSpotJustFreed => '✓ Завершён';

  @override
  String get createSpotTitle => 'Новая позиция';

  @override
  String get createSpotNumberLabel => 'Номер позиции';

  @override
  String get createSpotNumberHint => '1';

  @override
  String get createSpotNameLabel => 'Название позиции';

  @override
  String get createSpotNameHint => 'Позиция 1';

  @override
  String get createSpotDescLabel => 'Описание (ярлык)';

  @override
  String get createSpotDescHint => 'VIP зал, у окна, снукер...';

  @override
  String get createSpotDescPlaceholder => 'Описание';

  @override
  String get createSpotRateLabel => 'Тариф';

  @override
  String createSpotRateSuffix(String currency, String time_unit) {
    return '$currency/$time_unit';
  }

  @override
  String get createSpotButton => 'Создать позицию';

  @override
  String get editSpotTitle => 'Редактировать позицию';

  @override
  String get updateSpotButton => 'Обновить';

  @override
  String get deleteSpotButton => 'Удалить';

  @override
  String get deleteSpotSubtitle => 'История сессий сохранится, но позиция исчезнет с главной страницы.';

  @override
  String get createVenueTitle => 'Создайте зал';

  @override
  String get createVenueSubtitle =>
      'Дайте название вашему залу. Позиции можно будет добавить позже с главной страницы.';

  @override
  String get createVenueNameLabel => 'Название зала';

  @override
  String get createVenueNameHint => 'Центральный филиал';

  @override
  String get createVenueNumberLabel => 'Короткий код / номер (необязательно)';

  @override
  String get createVenueNumberHint => '№ 1 или ЦФ';

  @override
  String get createVenueInfoBanner =>
      'После создания зала вы сможете добавлять позиции по одной с собственным тарифом.';

  @override
  String get createVenueButton => 'Создать зал →';

  @override
  String get editVenueTitle => 'Редактировать зал';

  @override
  String get updateVenueButton => 'Обновить';

  @override
  String get deleteVenueButton => 'Удалить';

  @override
  String get deleteVenueSubtitle => 'Все позиции и история сессий сохранятся, но зал будет удалён.';

  @override
  String get cancel => 'Отмена';

  @override
  String get generalRetry => 'Повторить';

  @override
  String get createSpotTarifTypeLabel => 'Тип тарифа';

  @override
  String get tarifTypeMinute => 'Минута';

  @override
  String get tarifTypeHour => 'Час';

  @override
  String get tarifTypeDay => 'День';

  @override
  String get createSpotCurrencyLabel => 'Валюта';

  @override
  String get currencyKgs => 'Сом';

  @override
  String get currencyUsd => 'Доллар';

  @override
  String get currencyRub => 'Рубль';

  @override
  String get currencyKzt => 'Тенге';

  @override
  String get currencyTry => 'Лира';

  @override
  String venueSpotsCount(int count, String spot, String spotPlural) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count $spotPlural',
      one: '1 $spot',
      zero: 'нет $spotPlural',
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
  String get profileSectionManagement => 'Управление';

  @override
  String get profileManageVenuesTitle => 'Управление залами';

  @override
  String profileManageVenuesSubtitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count залов',
      many: '$count залов',
      few: '$count зала',
      one: '$count зал',
      zero: 'нет залов',
    );
    return '$_temp0';
  }

  @override
  String get profileManagersTitle => 'Менеджеры';

  @override
  String profileManagersSubtitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count менеджеров',
      many: '$count менеджеров',
      few: '$count менеджера',
      one: '$count менеджер',
      zero: 'нет менеджеров',
    );
    return '$_temp0';
  }

  @override
  String get profileSectionAccount => 'Аккаунт';

  @override
  String get profileSubscriptionTitle => 'Подписка';

  @override
  String profileSubscriptionActiveUntil(String date) {
    return 'Активна · до $date';
  }

  @override
  String get profileChangePasswordTitle => 'Сменить пароль';

  @override
  String get profileSettingsTitle => 'Настройки';

  @override
  String get profileSettingsSubtitle => 'Тема, язык';

  @override
  String get authUpdatePasswordTitle => 'Сменить пароль';

  @override
  String get authUpdatePasswordHint => 'Минимум 8 символов. Используйте буквы, цифры и спецсимволы.';

  @override
  String get authUpdatePasswordLoginLabel => 'Логин / Email';

  @override
  String get authUpdatePasswordNewLabel => 'Новый пароль';

  @override
  String get authUpdatePasswordRepeatLabel => 'Повторите новый пароль';

  @override
  String get authUpdatePasswordSubmit => 'Сохранить';

  @override
  String get authUpdatePasswordSuccess => 'Пароль обновлён';

  @override
  String get profileLogout => 'Выйти';

  @override
  String get profileLogoutTitle => 'Выйти из аккаунта?';

  @override
  String get profileLogoutSubtitle => 'Вы будете перенаправлены на экран входа. Данные сохранятся.';

  @override
  String get profileDeleteAccount => 'Удалить аккаунт';

  @override
  String get profileDeleteAccountTitle => 'Удалить аккаунт?';

  @override
  String get profileDeleteAccountSubtitle =>
      'Все данные, сессии и настройки будут безвозвратно удалены. Это действие нельзя отменить.';

  @override
  String get profileDeleteAccountConfirm => 'Удалить навсегда';

  @override
  String get profileErrorTitle => 'Не удалось загрузить профиль';

  @override
  String get profileErrorSubtitle => 'Проверьте подключение и попробуйте снова.';

  @override
  String get sessionCustomerName => 'Имя клиента (необязательно)';

  @override
  String get sessionCustomerNameHint => 'напр. Иван Иванов';

  @override
  String get spotDetailStart => 'НАЧАТЬ';

  @override
  String get spotDetailStop => 'ОСТАНОВИТЬ И ЗАКРЫТЬ';

  @override
  String get spotDetailElapsed => 'ПРОШЛО';

  @override
  String get spotDetailCurrentAmount => 'ТЕКУЩАЯ СУММА';

  @override
  String get spotDetailPause => 'ПАУЗА';

  @override
  String get spotDetailResume => 'ПРОДОЛЖИТЬ';

  @override
  String get spotDetailStartTime => 'Начало';

  @override
  String get spotDetailDuration => 'Длительность';

  @override
  String get spotDetailTariff => 'Тариф';

  @override
  String get spotDetailMistakeLaunch => 'Ошибочный запуск';

  @override
  String get spotDetailMistakeLaunchTitle => 'Отменить сессию?';

  @override
  String get spotDetailMistakeLaunchSubtitle => 'Сессия будет отменена без начисления оплаты.';

  @override
  String get spotDetailMistakeLaunchConfirm => 'Да, отменить';

  @override
  String get spotDetailLastSession => 'Прошлая сессия';

  @override
  String get spotDetailTodaySessions => 'Сегодня сессий';

  @override
  String get spotDetailPaymentTitle => 'Итоги оплаты';

  @override
  String get spotDetailSubtotal => 'Подытог';

  @override
  String get spotDetailDiscount => 'Скидка';

  @override
  String get spotDetailToPay => 'К ОПЛАТЕ';

  @override
  String get spotDetailConfirmAndClose => 'ПОДТВЕРДИТЬ И ЗАКРЫТЬ';

  @override
  String spotDetailDurationMin(int count) {
    return '$count мин';
  }

  @override
  String get spotLabelSpot => 'Стол';

  @override
  String get spotLabelConsole => 'Консоль';

  @override
  String get spotLabelCourt => 'Корт';

  @override
  String get spotLabelBoard => 'Доска';

  @override
  String get spotLabelPitch => 'Поле';

  @override
  String get spotLabelSpotPlural => 'Столы';

  @override
  String get spotLabelConsolePlural => 'Консоли';

  @override
  String get spotLabelCourtPlural => 'Корты';

  @override
  String get spotLabelBoardPlural => 'Доски';

  @override
  String get spotLabelPitchPlural => 'Поля';

  @override
  String get venueTypeSpotTennis => 'Настольный теннис';

  @override
  String get venueTypeBilliards => 'Бильярд';

  @override
  String get venueTypePlayStation => 'PlayStation';

  @override
  String get venueTypeVolleyball => 'Волейбол';

  @override
  String get venueTypeBasketball => 'Баскетбол';

  @override
  String get venueTypeChess => 'Шахматы';

  @override
  String get venueTypeFootball => 'Футбол';

  @override
  String get venueFormTypeLabel => 'Тип';

  @override
  String get venueFormTypeImmutableHint =>
      'Тип нельзя изменить после создания. Создайте новый зал, если меняется направление.';

  @override
  String get venueFormTypeRequiredError => 'Выберите тип зала';

  @override
  String get menuEdit => 'Редактировать';

  @override
  String get menuDelete => 'Удалить';

  @override
  String get managersInviteCodeLabel => 'АКТИВНЫЙ КОД ПРИГЛАШЕНИЯ';

  @override
  String get managersInviteCodeErrorLabel => 'КОД ПРИГЛАШЕНИЯ НЕДОСТУПЕН';

  @override
  String get managersInviteCodeCopy => 'Копировать';

  @override
  String get managersInviteCodeCopied => 'Код скопирован';

  @override
  String get managersSectionLabel => 'МЕНЕДЖЕРЫ';

  @override
  String get managersInviteAction => 'Пригласить менеджера';

  @override
  String managersDeleteTitle(String name) {
    return 'Удалить $name?';
  }

  @override
  String get managersDeleteSubtitle => 'Менеджер потеряет доступ к вашим залам. История его сессий сохранится.';

  @override
  String get managersEmptyTitle => 'Менеджеров пока нет';

  @override
  String get managersEmptySubtitle =>
      'Поделитесь кодом приглашения — менеджер сможет зарегистрироваться и выйти на смену.';

  @override
  String get managersLastSeenJustNow => 'онлайн';

  @override
  String managersLastSeenMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count мин назад',
      many: '$count мин назад',
      few: '$count мин назад',
      one: '$count мин назад',
    );
    return '$_temp0';
  }

  @override
  String managersLastSeenHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count часов назад',
      many: '$count часов назад',
      few: '$count часа назад',
      one: '$count час назад',
    );
    return '$_temp0';
  }

  @override
  String managersLastSeenDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count дней назад',
      many: '$count дней назад',
      few: '$count дня назад',
      one: '$count день назад',
    );
    return '$_temp0';
  }

  @override
  String venueSpotsCountSuffix(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count шт.',
      many: '$count шт.',
      few: '$count шт.',
      one: '$count шт.',
      zero: '0 шт.',
    );
    return '$_temp0';
  }

  @override
  String get subscriptionTitle => 'Подписка';

  @override
  String get subscriptionStatusActive => 'Активна';

  @override
  String get subscriptionStatusGrace => 'Льготный период';

  @override
  String get subscriptionStatusExpired => 'Истекла';

  @override
  String get subscriptionSourceTrial => 'Пробный период';

  @override
  String get subscriptionSourcePaid => 'Оплачена';

  @override
  String subscriptionWarningBanner(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'Подписка истекает через $n дн. Продлите, чтобы избежать перерыва.',
      one: 'Подписка истекает через 1 день. Продлите, чтобы избежать перерыва.',
    );
    return '$_temp0';
  }

  @override
  String subscriptionGraceBanner(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'Подписка истекла. Осталось $n дн. льготного периода.',
      one: 'Подписка истекла. Остался 1 день льготного периода.',
    );
    return '$_temp0';
  }

  @override
  String get subscriptionExpiredBanner => 'Подписка истекла. Продлите, чтобы пользоваться основными функциями.';

  @override
  String subscriptionPlanCardPerSpot(int price, String currency) {
    return '$price $currency / позиция / месяц';
  }

  @override
  String subscriptionPlanCardMonthly(int tableCount, int monthly, String currency) {
    return '× $tableCount позиций = $monthly $currency / месяц';
  }

  @override
  String get subscriptionDetailNextPayment => 'Следующий платёж';

  @override
  String get subscriptionDetailLastPayment => 'Последний платёж';

  @override
  String get subscriptionDetailStatus => 'Статус';

  @override
  String get subscriptionPaymentHistoryTitle => 'История платежей';

  @override
  String get subscriptionPaymentHistoryEmpty => 'Платежей пока нет';

  @override
  String subscriptionPaymentItemSummary(int months, int tableCount) {
    return '$months мес × $tableCount позиций';
  }

  @override
  String subscriptionAmountWithCurrency(int amount, String currency) {
    return '$amount $currency';
  }

  @override
  String get subscriptionContinueCta => 'Продлить подписку';

  @override
  String get subscriptionCheckoutTitle => 'Оплата';

  @override
  String subscriptionCheckoutSummary(int tableCount, int price, int monthly, String currency) {
    return '$tableCount позиций × $price $currency = $monthly $currency / мес';
  }

  @override
  String get subscriptionCheckoutDuration => 'Длительность';

  @override
  String subscriptionCheckoutMonthsLabel(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n мес',
      many: '$n мес',
      few: '$n мес',
      one: '$n мес',
    );
    return '$_temp0';
  }

  @override
  String get subscriptionCheckoutTotal => 'Итого';

  @override
  String subscriptionCheckoutTotalLine(int months, int monthly, int total, String currency) {
    return '$months мес × $monthly $currency = $total $currency';
  }

  @override
  String subscriptionCheckoutNewEndDate(String date) {
    return 'Новая дата окончания: $date';
  }

  @override
  String get subscriptionCheckoutPay => 'Оплатить';

  @override
  String get subscriptionCheckoutNoSpotsTitle => 'Позиций пока нет';

  @override
  String get subscriptionCheckoutNoSpotsSubtitle => 'Добавьте хотя бы одну позицию, чтобы оформить подписку.';

  @override
  String get subscriptionCheckoutGoToVenues => 'К залам';

  @override
  String get subscriptionPaymentMockTitle => 'Тестовая оплата';

  @override
  String get subscriptionPaymentMockSubtitle => 'Интеграция с настоящей оплатой скоро. Симулируйте результат ниже.';

  @override
  String get subscriptionPaymentSimulateSuccess => 'Имитировать успех';

  @override
  String get subscriptionPaymentSimulateFailure => 'Имитировать ошибку';

  @override
  String get subscriptionPaymentSuccessTitle => 'Оплата прошла';

  @override
  String subscriptionPaymentSuccessBody(String date) {
    return 'Подписка продлена до $date.';
  }

  @override
  String get subscriptionPaymentFailedTitle => 'Оплата не прошла';

  @override
  String get subscriptionPaymentFailedBody => 'Что-то пошло не так. Попробуйте ещё раз.';

  @override
  String get subscriptionPaymentRetry => 'Попробовать снова';

  @override
  String get subscriptionPaymentClose => 'Закрыть';

  @override
  String get subscriptionBlockedTitle => 'Нужна подписка';

  @override
  String get subscriptionBlockedSubtitle => 'Продлите подписку, чтобы пользоваться основными функциями.';

  @override
  String get subscriptionBlockedRenew => 'Продлить';

  @override
  String get subscriptionBlockedCancel => 'Не сейчас';

  @override
  String get subscriptionErrorTitle => 'Не удалось загрузить подписку';

  @override
  String get subscriptionErrorSubtitle => 'Проверьте подключение и попробуйте снова.';

  @override
  String get subscriptionContactSupportAction => 'Нужна помощь? Свяжитесь с поддержкой';

  @override
  String profileSubscriptionExpiresIn(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'Истекает через $n дн.',
      one: 'Истекает через 1 день',
    );
    return '$_temp0';
  }

  @override
  String profileSubscriptionGrace(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'Льготный · осталось $n дн.',
      one: 'Льготный · остался 1 день',
    );
    return '$_temp0';
  }

  @override
  String get profileSubscriptionExpired => 'Истекла';

  @override
  String get reportsOverviewTitle => 'Отчёты';

  @override
  String get reportsManagerDetailTitle => 'Менеджер';

  @override
  String get reportsSpotDetailTitle => 'Позиция';

  @override
  String get reportsPeriodToday => 'Сегодня';

  @override
  String get reportsPeriodWeek => 'Неделя';

  @override
  String get reportsPeriodMonth => 'Месяц';

  @override
  String get reportsPeriodYear => 'Год';

  @override
  String get reportsPeriodCustom => 'Период';

  @override
  String get reportsVenuePickerTitle => 'Выберите зал';

  @override
  String get reportsKpiRevenue => 'Общая выручка';

  @override
  String get reportsKpiSessions => 'Сессии';

  @override
  String get reportsRevenueChartTitle => 'Выручка по дням';

  @override
  String get reportsRevenueChartCompareToggle => 'Сравнить с прошлым периодом';

  @override
  String get reportsTopManagersTitle => 'Менеджеры';

  @override
  String get reportsSpotLabel => 'Позиция';

  @override
  String get reportsSessionsShort => 'сессий';

  @override
  String get reportsCancelledShort => 'отмен';

  @override
  String get reportsSessionLogTitle => 'Лог сессий';

  @override
  String get reportsLogFilterAll => 'Все';

  @override
  String get reportsLogFilterCancelled => 'Отменённые';

  @override
  String get reportsLogStatusActive => 'В процессе';

  @override
  String get reportsLogEmpty => 'Нет сессий по этому фильтру.';

  @override
  String get reportsForecastSummaryTitle => 'Прогноз';

  @override
  String get reportsForecastVsPrevious => 'к прошлому периоду';

  @override
  String reportsForecastVsRange(String previous) {
    return 'к $previous';
  }

  @override
  String get reportsForecastNoComparison => 'Истории пока недостаточно';

  @override
  String reportsComparisonCaption(String current, String previous) {
    return '$current  ·  vs $previous';
  }

  @override
  String get reportsSpotTrendTitle => 'Тренд выручки';

  @override
  String get reportsSpotHeatmapTitle => 'Карта по часам';

  @override
  String get reportsErrorTitle => 'Не удалось загрузить отчёт';

  @override
  String get reportsEmptyTitle => 'Данных пока нет';

  @override
  String get reportsEmptySubtitle => 'Начните сессии, чтобы здесь появились цифры.';

  @override
  String get upgraderRequiredTitle => 'Необходимо обновление';

  @override
  String get upgraderRecommendedTitle => 'Доступно обновление';

  @override
  String get upgraderRequiredDescription =>
      'Эта версия больше не поддерживается. Обновите приложение, чтобы продолжить.';

  @override
  String get upgraderRecommendedDescription => 'Доступна новая версия. Обновите для лучшего опыта.';

  @override
  String get upgraderUpdateButton => 'Обновить';

  @override
  String get upgraderLaterButton => 'Позже';

  @override
  String get currencyLabel => 'сом';

  @override
  String get profileProductsTitle => 'Товары и цены';

  @override
  String get profileProductsSubtitle => 'Напитки, еда, аренда';

  @override
  String get productsTitle => 'Товары и цены';

  @override
  String get productsFilterAll => 'Все';

  @override
  String get productsAddButton => 'Добавить товар';

  @override
  String get productsCreateTitle => 'Новый товар';

  @override
  String get productsEditTitle => 'Редактировать товар';

  @override
  String get productsCreateButton => 'Создать товар';

  @override
  String get productsUpdateButton => 'Обновить';

  @override
  String get productsEmptyTitle => 'Товаров пока нет';

  @override
  String get productsEmptySubtitle => 'Добавьте первый товар для начала продаж.';

  @override
  String productsDeleteTitle(String name) {
    return 'Удалить \"$name\"?';
  }

  @override
  String get productsDeleteSubtitle => 'Товар будет скрыт и не будет отображаться в активных сессиях.';

  @override
  String get productsNameLabel => 'Название';

  @override
  String get productsNameHint => 'напр. Вода 0.5л';

  @override
  String get productsPriceLabel => 'Цена';

  @override
  String get productsPriceHint => 'напр. 50';

  @override
  String get productsPriceInvalid => 'Введите корректную цену больше 0';

  @override
  String get productsCategoryLabel => 'Категория';

  @override
  String get productsUnitLabel => 'Единица измерения';

  @override
  String get productsDescriptionLabel => 'Описание (необязательно)';

  @override
  String get productsDescriptionHint => 'Краткое описание...';

  @override
  String get productsPhotoSectionLabel => 'Фото (необязательно)';

  @override
  String get productsIconPickerLabel => 'Или выберите иконку:';

  @override
  String get productsPhotoPickerLabel => 'Добавить';

  @override
  String get productCategoryDrink => 'Напитки';

  @override
  String get productCategoryFood => 'Еда';

  @override
  String get productCategoryEquipment => 'Аренда';

  @override
  String get productCategoryOther => 'Прочее';

  @override
  String get productUnitPiece => 'Штука';

  @override
  String get productUnitKg => 'кг';

  @override
  String get productUnitLitre => 'Литр';

  @override
  String get productUnitPortion => 'Порция';

  @override
  String get productUnitHour => 'Час';

  @override
  String get productUnitPieceShort => 'шт';

  @override
  String get productUnitKgShort => 'кг';

  @override
  String get productUnitLitreShort => 'л';

  @override
  String get productUnitPortionShort => 'порц.';

  @override
  String get productUnitHourShort => 'ч';
}
