import 'package:api_client/api_client.dart';
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
  unknown
  ;

  factory SubscriptionErrorCode.fromString(String? code) {
    return switch (code) {
      'SUBSCRIPTION_REQUIRED' => .subscriptionRequired,
      'NO_TABLES' => .noTables,
      'INVALID_DURATION' => .invalidDuration,
      'PAYMENT_NOT_FOUND' => .paymentNotFound,
      'PAYMENT_ALREADY_PROCESSED' => .paymentAlreadyProcessed,
      'PAYMENT_PROVIDER_ERROR' => .paymentProviderError,
      'PRICING_MISMATCH' => .pricingMismatch,
      'FORBIDDEN' => .forbidden,
      _ => .unknown,
    };
  }
}

final class SubscriptionExc extends AppException<SubscriptionErrorCode> {
  const SubscriptionExc(
    super.error, {
    super.message,
    super.handleType,
  });

  factory SubscriptionExc.fromApiClientExc(ApiClientException e) {
    return SubscriptionExc(
      SubscriptionErrorCode.fromString(e.code),
      message: e.message,
    );
  }

  @override
  ErrorModel getModel() => ErrorModel(
    title: _title,
    message: getUiMessage(),
  );

  BaseMessage get _title => switch (error) {
    .paymentNotFound || .paymentAlreadyProcessed || .paymentProviderError || .pricingMismatch => const BaseMessage(
      en: 'Payment Error',
      ru: 'Ошибка оплаты',
      ky: 'Төлөм катасы',
    ),
    .subscriptionRequired || .noTables || .invalidDuration || .forbidden || .unknown => BaseMessage.base,
  };

  @override
  BaseMessage getUiMessage() => switch (error) {
    .subscriptionRequired => const BaseMessage(
      en: 'Subscription expired. Renew to continue using core features.',
      ru: 'Подписка истекла. Продлите её, чтобы продолжить пользоваться основными функциями.',
      ky: 'Жазылуу бүттү. Негизги функцияларды колдонуу үчүн узартыңыз.',
    ),
    .noTables => const BaseMessage(
      en: 'Add at least one table before subscribing.',
      ru: 'Добавьте хотя бы один стол, чтобы оформить подписку.',
      ky: 'Жазылуу үчүн жок дегенде бир стол кошуңуз.',
    ),
    .invalidDuration => const BaseMessage(
      en: 'Selected duration is not allowed.',
      ru: 'Выбранная длительность недопустима.',
      ky: 'Тандалган узактык туура эмес.',
    ),
    .paymentNotFound => const BaseMessage(
      en: 'Payment not found.',
      ru: 'Платёж не найден.',
      ky: 'Төлөм табылган жок.',
    ),
    .paymentAlreadyProcessed => const BaseMessage(
      en: 'This payment has already been processed.',
      ru: 'Этот платёж уже обработан.',
      ky: 'Бул төлөм мурунтан иштетилген.',
    ),
    .paymentProviderError => const BaseMessage(
      en: 'Payment provider error. Please try again later.',
      ru: 'Ошибка платёжного провайдера. Повторите позже.',
      ky: 'Төлөм провайдеринде ката. Кийинчерээк аракет кылыңыз.',
    ),
    .pricingMismatch => const BaseMessage(
      en: 'Pricing has changed. Please reload and try again.',
      ru: 'Цены изменились. Обновите и попробуйте снова.',
      ky: 'Баа өзгөрдү. Жаңылап, кайра аракет кылыңыз.',
    ),
    .forbidden => const BaseMessage(
      en: 'You do not have permission to perform this action.',
      ru: 'У вас нет прав для выполнения этого действия.',
      ky: 'Сизде бул аракетти аткаруу укугу жок.',
    ),
    .unknown => message ?? BaseMessage.defaultUiMessage,
  };
}
