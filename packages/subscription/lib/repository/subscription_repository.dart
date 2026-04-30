import 'package:meta/meta.dart';
import 'package:subscription/models/checkout_param.dart';
import 'package:subscription/models/payment_model.dart';
import 'package:subscription/models/payment_outcome.dart';
import 'package:subscription/models/subscription_detail_model.dart';
import 'package:subscription/models/subscription_pricing_model.dart';
import 'package:subscription/source/remote/subscription_remote_source.dart';

@immutable
final class SubscriptionRepository {
  const SubscriptionRepository(this._remote);

  final SubscriptionRemoteSource _remote;

  Future<SubscriptionDetailModel> getSubscription() {
    return _remote.getSubscription();
  }

  Future<SubscriptionPricingModel> getPricing() {
    return _remote.getPricing();
  }

  Future<PaymentModel> createCheckout(int months) {
    return _remote.createCheckout(CheckoutParam(months));
  }

  Future<PaymentModel> getPayment(String id) {
    return _remote.getPayment(id);
  }

  Future<PaymentModel> confirmMockPayment(
    String id,
    PaymentOutcome outcome,
  ) {
    return _remote.confirmMockPayment(id, outcome);
  }
}
