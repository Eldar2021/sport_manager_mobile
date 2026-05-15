import 'package:api_client/api_client.dart';
import 'package:core/core.dart';

enum ManagerErrorCode {
  notFound,
  forbidden,
  hasActiveSession,
  unknown;

  factory ManagerErrorCode.fromString(String? code) {
    return switch (code) {
      'MANAGER_NOT_FOUND' => .notFound,
      'FORBIDDEN' => .forbidden,
      'HAS_ACTIVE_SESSION' => .hasActiveSession,
      _ => .unknown,
    };
  }
}

final class ManagerExc extends AppException<ManagerErrorCode> {
  const ManagerExc(
    super.error, {
    super.message,
    super.handleType,
  });

  factory ManagerExc.fromApiClientExc(ApiClientException e) {
    return ManagerExc(
      ManagerErrorCode.fromString(e.code),
      message: e.message,
    );
  }

  @override
  ErrorModel getModel() => ErrorModel(
    title: _title,
    message: getUiMessage(),
  );

  BaseMessage get _title => switch (error) {
    .notFound || .forbidden || .hasActiveSession || .unknown => BaseMessage.base,
  };

  @override
  BaseMessage getUiMessage() => switch (error) {
    .notFound => const BaseMessage(
      en: 'Manager not found',
      ru: 'Менеджер не найден',
      ky: 'Менеджер табылган жок',
    ),
    .forbidden => const BaseMessage(
      en: 'You do not have permission to perform this action',
      ru: 'У вас нет прав для выполнения этого действия',
      ky: 'Сизде бул аракетти аткаруу укугу жок',
    ),
    .hasActiveSession => const BaseMessage(
      en: 'Cannot remove a manager with an active session',
      ru: 'Нельзя удалить менеджера с активной сессией',
      ky: 'Активдүү сессиясы бар менеджерди жок кылуу мүмкүн эмес',
    ),
    .unknown => message ?? BaseMessage.defaultUiMessage,
  };
}
