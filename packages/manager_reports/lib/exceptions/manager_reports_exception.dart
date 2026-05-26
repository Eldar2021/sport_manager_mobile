import 'package:api_client/api_client.dart';
import 'package:core/core.dart';

enum ManagerReportsErrorCode {
  badRequest,
  invalidTimezone,
  invalidDate,
  invalidYearMonth,
  forbidden,
  unknown
  ;

  factory ManagerReportsErrorCode.fromString(String? code) {
    return switch (code) {
      'BAD_REQUEST' => .badRequest,
      'INVALID_TIMEZONE' => .invalidTimezone,
      'INVALID_DATE' => .invalidDate,
      'INVALID_YEAR_MONTH' => .invalidYearMonth,
      'FORBIDDEN' => .forbidden,
      _ => .unknown,
    };
  }
}

final class ManagerReportsExc extends AppException<ManagerReportsErrorCode> {
  const ManagerReportsExc(
    super.error, {
    super.message,
    super.handleType,
  });

  factory ManagerReportsExc.fromApiClientExc(ApiClientException e) {
    return ManagerReportsExc(
      ManagerReportsErrorCode.fromString(e.code),
      message: e.message,
    );
  }

  @override
  ErrorModel getModel() => ErrorModel(
    title: _title,
    message: getUiMessage(),
  );

  BaseMessage get _title => switch (error) {
    .badRequest || .invalidTimezone || .invalidDate || .invalidYearMonth || .forbidden || .unknown => BaseMessage.base,
  };

  @override
  BaseMessage getUiMessage() => switch (error) {
    .badRequest => const BaseMessage(
      en: 'Invalid request',
      ru: 'Некорректный запрос',
      ky: 'Туура эмес сурам',
    ),
    .invalidTimezone => const BaseMessage(
      en: 'Invalid timezone identifier',
      ru: 'Некорректный часовой пояс',
      ky: 'Жараксыз убакыт алкагы',
    ),
    .invalidDate => const BaseMessage(
      en: 'Invalid date',
      ru: 'Некорректная дата',
      ky: 'Жараксыз күн',
    ),
    .invalidYearMonth => const BaseMessage(
      en: 'Invalid year/month value',
      ru: 'Некорректный год/месяц',
      ky: 'Жараксыз жыл/ай',
    ),
    .forbidden => const BaseMessage(
      en: 'You do not have permission to view these reports',
      ru: 'У вас нет доступа к этим отчётам',
      ky: 'Бул отчётторду көрүү укугуңуз жок',
    ),
    .unknown => message ?? BaseMessage.defaultUiMessage,
  };
}
