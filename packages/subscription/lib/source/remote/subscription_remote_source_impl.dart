import 'package:api_client/api_client.dart';
import 'package:meta/meta.dart';
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

  @override
  Future<SubscriptionDetailModel> getSubscription() {
    return _client.getType<SubscriptionDetailModel>(
      '/subscription',
      fromJson: SubscriptionDetailModel.fromJson,
    );
  }

  @override
  Future<SubscriptionPricingModel> getPricing() {
    return _client.getType<SubscriptionPricingModel>(
      '/subscription/pricing',
      fromJson: SubscriptionPricingModel.fromJson,
    );
  }

  @override
  Future<PaymentModel> createCheckout(CheckoutParam param) {
    return _client.postType<PaymentModel>(
      '/subscription/checkout',
      data: param.toJson(),
      fromJson: PaymentModel.fromJson,
    );
  }

  @override
  Future<PaymentModel> getPayment(String id) {
    return _client.getType<PaymentModel>(
      '/subscription/payment/$id',
      fromJson: PaymentModel.fromJson,
    );
  }

  @override
  Future<PaymentModel> confirmMockPayment(
    String id,
    PaymentOutcome outcome,
  ) {
    return _client.postType<PaymentModel>(
      '/subscription/payment/$id/confirm',
      data: <String, dynamic>{'outcome': _encodeOutcome(outcome)},
      fromJson: PaymentModel.fromJson,
    );
  }

  static String _encodeOutcome(PaymentOutcome outcome) {
    return switch (outcome) {
      PaymentOutcome.paid => 'PAID',
      PaymentOutcome.failed => 'FAILED',
    };
  }
}
