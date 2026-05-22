import 'package:flutter/material.dart';

@immutable
final class ErrorModel {
  const ErrorModel({
    required this.title,
    required this.message,
    this.icon,
  });

  final Widget? icon;
  final BaseMessage title;
  final BaseMessage message;
}

@immutable
final class BaseMessage {
  const BaseMessage({
    required this.en,
    required this.ru,
    required this.ky,
  });

  final String en;
  final String ru;
  final String ky;

  String getMessage(String locale) {
    return switch (locale) {
      'en' || 'EN' || 'En' => en,
      'ru' || 'RU' || 'Ru' => ru,
      'ky' || 'KY' || 'Ky' => ky,
      _ => en,
    };
  }

  static const base = BaseMessage(
    en: 'Something went wrong',
    ru: 'Что-то пошло не так',
    ky: 'Бир нерсе туура эмес болуп калды',
  );

  static const technical = BaseMessage(
    en: 'Technical error contact support',
    ru: 'Техническая ошибка свяжитесь с поддержкой',
    ky: 'Техникалык ката байланышыңызды колдоого',
  );

  static const connection = BaseMessage(
    en: 'Connection error',
    ru: 'Ошибка соединения',
    ky: 'Байланыш катасы',
  );

  static const noInternetConnection = BaseMessage(
    en: 'Check your internet connection or refresh the page',
    ru: 'Проверьте ваше интернет-соединение или обновите страницу',
    ky: 'Интернет байланышыңызды текшериңиз же баракты жаңыртыңыз',
  );

  static const sessionExpired = BaseMessage(
    en: 'Your session has expired. Please log in again!',
    ru: 'Ваша сессия истекла. Пожалуйста, войдите снова!',
    ky: 'Кайрылуу убакыты бүтүп калды. Сураныч,авторизовацияны кайталаңыз!',
  );

  static const serviceUnavailable = BaseMessage(
    en: 'Service unavailable',
    ru: 'Сервис недоступен',
    ky: 'Кызмат жеткиликсиз',
  );

  static const authException = BaseMessage(
    en: 'Authentication Error',
    ru: 'Ошибка авторизации',
    ky: 'Авторизация катасы',
  );

  static const venueError = BaseMessage(
    en: 'Venue Error',
    ru: 'Ошибка заведения',
    ky: 'Жай катасы',
  );

  static const spotError = BaseMessage(
    en: 'Spot Error',
    ru: 'Ошибка позиции',
    ky: 'Позиция катасы',
  );

  static const sessionError = BaseMessage(
    en: 'Session Error',
    ru: 'Ошибка сессии',
    ky: 'Сессия катасы',
  );

  static const defaultUiMessage = BaseMessage(
    en: 'Something went wrong. Please try again.',
    ru: 'Что-то пошло не так. Попробуйте ещё раз.',
    ky: 'Бир нерсе туура эмес болуп калды. Кайра аракет кылыңыз.',
  );
}
