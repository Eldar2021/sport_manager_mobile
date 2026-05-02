import 'package:core/core.dart';

enum ReportsErrorCode {
  notFound,
  forbidden,
  notEnoughData,
  unknown,
}

final class ReportsException extends AppException<ReportsErrorCode> {
  const ReportsException(
    super.error, {
    super.message,
    super.handleType,
  });

  @override
  ErrorModel getModel() => ErrorModel(
    title: BaseMessage.defaultUiMessage,
    message: getUiMessage(),
  );

  @override
  BaseMessage getUiMessage() => switch (error) {
    ReportsErrorCode.notFound => const BaseMessage(
      en: 'Report data not found',
      ru: 'Данные отчёта не найдены',
      ky: 'Отчёт маалыматтары табылган жок',
    ),
    ReportsErrorCode.forbidden => const BaseMessage(
      en: 'You do not have permission to view this report',
      ru: 'У вас нет доступа к этому отчёту',
      ky: 'Бул отчётту көрүү укугуңуз жок',
    ),
    ReportsErrorCode.notEnoughData => const BaseMessage(
      en: 'Not enough data yet — start sessions to populate reports',
      ru: 'Данных пока недостаточно — начните сессии для отчётов',
      ky: 'Маалымат али жетишсиз — отчёт үчүн сессияларды баштаңыз',
    ),
    ReportsErrorCode.unknown => message ?? BaseMessage.defaultUiMessage,
  };
}
