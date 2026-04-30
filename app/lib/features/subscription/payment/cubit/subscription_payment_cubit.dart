import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sport_manager_mobile/core/core.dart';
import 'package:subscription/subscription.dart';

class SubscriptionPaymentCubit extends Cubit<DataState<PaymentModel>> {
  SubscriptionPaymentCubit(
    this._repository,
    PaymentModel initial,
  ) : super(DataSuccess<PaymentModel>(initial));

  final SubscriptionRepository _repository;

  Future<void> confirmMock(PaymentOutcome outcome) async {
    final current = state.dataValue;
    if (current == null) return;
    emit(const DataLoading<PaymentModel>());
    try {
      final updated = await _repository.confirmMockPayment(
        current.id,
        outcome,
      );
      emit(DataSuccess<PaymentModel>(updated));
    } on Object catch (e) {
      emit(DataFailure<PaymentModel>(e));
    }
  }

  Future<void> refresh() async {
    final current = state.dataValue;
    if (current == null) return;
    try {
      final updated = await _repository.getPayment(current.id);
      emit(DataSuccess<PaymentModel>(updated));
    } on Object catch (e) {
      emit(DataFailure<PaymentModel>(e));
    }
  }
}
