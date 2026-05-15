import 'package:api_client/api_client.dart';
import 'package:core/core.dart';

enum ReportsErrorCode {
  notFound,
  forbidden,
  notEnoughData,
  unknown
  ;

  factory ReportsErrorCode.fromString(String? code) {
    return switch (code) {
      'REPORT_NOT_FOUND' || 'VENUE_NOT_FOUND' || 'TABLE_NOT_FOUND' || 'MANAGER_NOT_FOUND' => .notFound,
      'FORBIDDEN' => .forbidden,
      'NOT_ENOUGH_DATA' => .notEnoughData,
      _ => .unknown,
    };
  }
}

final class ReportsExc extends AppException<ReportsErrorCode> {
  const ReportsExc(
    super.error, {
    super.message,
    super.handleType,
  });

  factory ReportsExc.fromApiClientExc(ApiClientException e) {
    return ReportsExc(
      ReportsErrorCode.fromString(e.code),
      message: e.message,
    );
  }

  @override
  ErrorModel getModel() => ErrorModel(
    title: _title,
    message: getUiMessage(),
  );

  BaseMessage get _title => switch (error) {
    .notFound || .notEnoughData || .forbidden => BaseMessage.base,
    .unknown => BaseMessage.base,
  };

  @override
  BaseMessage getUiMessage() => switch (error) {
    .notFound => const BaseMessage(
      en: 'Report data not found',
      ru: 'Данные отчёта не найдены',
      ky: 'Отчёт маалыматтары табылган жок',
    ),
    .forbidden => const BaseMessage(
      en: 'You do not have permission to view this report',
      ru: 'У вас нет доступа к этому отчёту',
      ky: 'Бул отчётту көрүү укугуңуз жок',
    ),
    .notEnoughData => const BaseMessage(
      en: 'Not enough data yet — start sessions to populate reports',
      ru: 'Данных пока недостаточно — начните сессии для отчётов',
      ky: 'Маалымат али жетишсиз — отчёт үчүн сессияларды баштаңыз',
    ),
    .unknown => message ?? BaseMessage.defaultUiMessage,
  };
}
