import 'package:api_client/api_client.dart';
import 'package:meta/meta.dart';
import 'package:subscription/exceptions/subscription_exception.dart';
import 'package:subscription/models/checkout_param.dart';
import 'package:subscription/models/payment_model.dart';
import 'package:subscription/models/payment_outcome.dart';
import 'package:subscription/models/subscription_detail_model.dart';
import 'package:subscription/models/subscription_pricing_model.dart';
import 'package:subscription/source/remote/subscription_remote_source.dart';

@immutable
final class SubscriptionRemoteSourceImpl implements SubscriptionRemoteSource {
  const SubscriptionRemoteSourceImpl(this._client);

  final ApiClient _client;

  static const _baseUrl = 'api/v1/subscription';

  @override
  Future<SubscriptionDetailModel> getSubscription() {
    return _client
        .getType<SubscriptionDetailModel>(
          _baseUrl,
          fromJson: SubscriptionDetailModel.fromJson,
        )
        .mapTo(SubscriptionExc.fromApiClientExc);
  }

  @override
  Future<SubscriptionPricingModel> getPricing() {
    return _client
        .getType<SubscriptionPricingModel>(
          '$_baseUrl/pricing',
          fromJson: SubscriptionPricingModel.fromJson,
        )
        .mapTo(SubscriptionExc.fromApiClientExc);
  }

  @override
  Future<PaymentModel> createCheckout(CheckoutParam param) {
    return _client
        .postType<PaymentModel>(
          '$_baseUrl/checkout',
          data: param.toJson(),
          fromJson: PaymentModel.fromJson,
        )
        .mapTo(SubscriptionExc.fromApiClientExc);
  }

  @override
  Future<PaymentModel> getPayment(String id) {
    return _client
        .getType<PaymentModel>(
          '$_baseUrl/payment/$id',
          fromJson: PaymentModel.fromJson,
        )
        .mapTo(SubscriptionExc.fromApiClientExc);
  }

  @override
  Future<PaymentModel> confirmMockPayment(
    String id,
    PaymentOutcome outcome,
  ) {
    return _client
        .postType<PaymentModel>(
          '$_baseUrl/payment/$id/confirm',
          data: <String, dynamic>{'outcome': _encodeOutcome(outcome)},
          fromJson: PaymentModel.fromJson,
        )
        .mapTo(SubscriptionExc.fromApiClientExc);
  }

  static String _encodeOutcome(PaymentOutcome outcome) {
    return switch (outcome) {
      PaymentOutcome.paid => 'PAID',
      PaymentOutcome.failed => 'FAILED',
    };
  }
}
