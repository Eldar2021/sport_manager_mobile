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
  String get settingsAppearance => 'Внешний вид';

  @override
  String get settingsLanguage => 'Язык';

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
  String get authSignInSubtitle => 'Введите данные для входа';

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
  String get authChooseRoleSubtitle => 'Это определит доступные функции';

  @override
  String get authOwnerTitle => 'Владелец зала';

  @override
  String get authOwnerSubtitle => 'Управляю одним или несколькими залами';

  @override
  String get authManagerTitle => 'Менеджер зала';

  @override
  String get authManagerSubtitle => 'Работаю на смене, нужен код приглашения';

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
  String get authConfirmPasswordLabel => 'Повторите пароль';

  @override
  String get authAgreeTerms => 'Согласен с условиями';

  @override
  String get authAgreeTermsError => 'Необходимо согласиться с условиями';

  @override
  String get authCreateAccount => 'Создать аккаунт';

  @override
  String get authInviteCodeHint => 'Получите код приглашения у владельца зала';

  @override
  String get authFieldRequired => 'Поле обязательно для заполнения';

  @override
  String get authPasswordMinLength => 'Пароль должен содержать не менее 8 символов';

  @override
  String get authPasswordsDoNotMatch => 'Пароли не совпадают';

  @override
  String get authInvalidEmail => 'Введите корректный email';

  @override
  String get authInvalidPhone => 'Введите корректный номер телефона';
}
