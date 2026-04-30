import 'package:core/core.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:subscription/subscription.dart';

part 'subscription_state.dart';

class SubscriptionCubit extends Cubit<SubscriptionState> {
  SubscriptionCubit(this._repository) : super(const SubscriptionState());

  final SubscriptionRepository _repository;

  Future<void> loadSummary() async {
    emit(state.copyWith(summary: const RequestLoading<SubscriptionSummaryModel>()));
    try {
      final detail = await _repository.getSubscription();
      final s = detail.subscription;
      final summary = SubscriptionSummaryModel(
        status: s.status,
        endDate: s.endDate,
        daysUntilExpiry: s.daysUntilExpiry,
        graceDaysRemaining: s.graceDaysRemaining,
      );
      emit(state.copyWith(summary: RequestSuccess<SubscriptionSummaryModel>(summary)));
    } on Object catch (e) {
      emit(state.copyWith(summary: RequestFailure<SubscriptionSummaryModel>(e)));
    }
  }

  Future<void> refresh() => loadSummary();

  void clear() => emit(const SubscriptionState());
}
