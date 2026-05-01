import 'package:core/core.dart';

enum SubscriptionErrorCode {
  subscriptionRequired,
  noTables,
  invalidDuration,
  paymentNotFound,
  paymentAlreadyProcessed,
  paymentProviderError,
  pricingMismatch,
  forbidden,
  unknown,
}

final class SubscriptionException extends AppException<SubscriptionErrorCode> {
  const SubscriptionException(
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
    SubscriptionErrorCode.subscriptionRequired => const BaseMessage(
      en: 'Subscription expired. Renew to continue using core features.',
      ru: 'Подписка истекла. Продлите её, чтобы продолжить пользоваться основными функциями.',
      ky: 'Жазылуу бүттү. Негизги функцияларды колдонуу үчүн узартыңыз.',
    ),
    SubscriptionErrorCode.noTables => const BaseMessage(
      en: 'Add at least one table before subscribing.',
      ru: 'Добавьте хотя бы один стол, чтобы оформить подписку.',
      ky: 'Жазылуу үчүн жок дегенде бир стол кошуңуз.',
    ),
    SubscriptionErrorCode.invalidDuration => const BaseMessage(
      en: 'Selected duration is not allowed.',
      ru: 'Выбранная длительность недопустима.',
      ky: 'Тандалган узактык туура эмес.',
    ),
    SubscriptionErrorCode.paymentNotFound => const BaseMessage(
      en: 'Payment not found.',
      ru: 'Платёж не найден.',
      ky: 'Төлөм табылган жок.',
    ),
    SubscriptionErrorCode.paymentAlreadyProcessed => const BaseMessage(
      en: 'This payment has already been processed.',
      ru: 'Этот платёж уже обработан.',
      ky: 'Бул төлөм мурунтан иштетилген.',
    ),
    SubscriptionErrorCode.paymentProviderError => const BaseMessage(
      en: 'Payment provider error. Please try again later.',
      ru: 'Ошибка платёжного провайдера. Повторите позже.',
      ky: 'Төлөм провайдеринде ката. Кийинчерээк аракет кылыңыз.',
    ),
    SubscriptionErrorCode.pricingMismatch => const BaseMessage(
      en: 'Pricing has changed. Please reload and try again.',
      ru: 'Цены изменились. Обновите и попробуйте снова.',
      ky: 'Баа өзгөрдү. Жаңылап, кайра аракет кылыңыз.',
    ),
    SubscriptionErrorCode.forbidden => const BaseMessage(
      en: 'You do not have permission to perform this action.',
      ru: 'У вас нет прав для выполнения этого действия.',
      ky: 'Сизде бул аракетти аткаруу укугу жок.',
    ),
    SubscriptionErrorCode.unknown => message ?? BaseMessage.defaultUiMessage,
  };
}
