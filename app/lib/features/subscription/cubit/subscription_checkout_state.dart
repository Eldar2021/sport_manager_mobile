part of 'subscription_checkout_cubit.dart';

@immutable
final class SubscriptionCheckoutState extends Equatable {
  const SubscriptionCheckoutState({
    this.pricing = const RequestInitial<SubscriptionPricingModel>(),
    this.checkout = const RequestInitial<PaymentModel>(),
    this.months = 1,
  });

  final RequestStatus<SubscriptionPricingModel> pricing;
  final RequestStatus<PaymentModel> checkout;
  final int months;

  int get totalAmount {
    final p = pricing.dataOrNull;
    return p == null ? 0 : p.totalAmountFor(months);
  }

  DateTime get newEndDate {
    return DateTime.now().add(Duration(days: months * 30));
  }

  SubscriptionCheckoutState copyWith({
    RequestStatus<SubscriptionPricingModel>? pricing,
    RequestStatus<PaymentModel>? checkout,
    int? months,
  }) {
    return SubscriptionCheckoutState(
      pricing: pricing ?? this.pricing,
      checkout: checkout ?? this.checkout,
      months: months ?? this.months,
    );
  }

  @override
  List<Object?> get props => [
    pricing,
    checkout,
    months,
  ];
}
