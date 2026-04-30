import 'package:core/core.dart';

enum ManagerErrorCode {
  notFound,
  forbidden,
  hasActiveSession,
  unknown,
}

final class ManagerException extends AppException<ManagerErrorCode> {
  const ManagerException(
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
    ManagerErrorCode.notFound => const BaseMessage(
      en: 'Manager not found',
      ru: 'Менеджер не найден',
      ky: 'Менеджер табылган жок',
    ),
    ManagerErrorCode.forbidden => const BaseMessage(
      en: 'You do not have permission to perform this action',
      ru: 'У вас нет прав для выполнения этого действия',
      ky: 'Сизде бул аракетти аткаруу укугу жок',
    ),
    ManagerErrorCode.hasActiveSession => const BaseMessage(
      en: 'Cannot remove a manager with an active session',
      ru: 'Нельзя удалить менеджера с активной сессией',
      ky: 'Активдүү сессиясы бар менеджерди жок кылуу мүмкүн эмес',
    ),
    ManagerErrorCode.unknown => message ?? BaseMessage.defaultUiMessage,
  };
}
