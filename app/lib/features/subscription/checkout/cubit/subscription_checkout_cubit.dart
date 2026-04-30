import 'package:core/core.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:subscription/subscription.dart';

part 'subscription_checkout_state.dart';

class SubscriptionCheckoutCubit extends Cubit<SubscriptionCheckoutState> {
  SubscriptionCheckoutCubit(this._repository) : super(const SubscriptionCheckoutState());

  final SubscriptionRepository _repository;

  Future<void> loadPricing() async {
    emit(state.copyWith(pricing: const RequestLoading<SubscriptionPricingModel>()));
    try {
      final pricing = await _repository.getPricing();
      emit(
        state.copyWith(
          pricing: RequestSuccess<SubscriptionPricingModel>(pricing),
          months: state.months.clamp(
            pricing.minDurationMonths,
            pricing.maxDurationMonths,
          ),
        ),
      );
    } on Object catch (e) {
      emit(state.copyWith(pricing: RequestFailure<SubscriptionPricingModel>(e)));
    }
  }

  void setMonths(int months) {
    final pricing = state.pricing.dataOrNull;
    if (pricing == null) {
      emit(state.copyWith(months: months));
      return;
    }
    final clamped = months.clamp(
      pricing.minDurationMonths,
      pricing.maxDurationMonths,
    );
    emit(state.copyWith(months: clamped));
  }

  Future<PaymentModel?> checkout() async {
    final pricing = state.pricing.dataOrNull;
    if (pricing == null) return null;
    emit(state.copyWith(checkout: const RequestLoading<PaymentModel>()));
    try {
      final payment = await _repository.createCheckout(state.months);
      emit(state.copyWith(checkout: RequestSuccess<PaymentModel>(payment)));
      return payment;
    } on Object catch (e) {
      emit(state.copyWith(checkout: RequestFailure<PaymentModel>(e)));
      rethrow;
    }
  }
}
