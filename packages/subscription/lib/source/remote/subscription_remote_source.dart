import 'package:subscription/models/checkout_param.dart';
import 'package:subscription/models/payment_model.dart';
import 'package:subscription/models/payment_outcome.dart';
import 'package:subscription/models/subscription_detail_model.dart';
import 'package:subscription/models/subscription_pricing_model.dart';

abstract interface class SubscriptionRemoteSource {
  Future<SubscriptionDetailModel> getSubscription();

  Future<SubscriptionPricingModel> getPricing();

  Future<PaymentModel> createCheckout(CheckoutParam param);

  Future<PaymentModel> getPayment(String id);

  Future<PaymentModel> confirmMockPayment(
    String id,
    PaymentOutcome outcome,
  );
}
