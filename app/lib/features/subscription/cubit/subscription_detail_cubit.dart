import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sport_manager_mobile/core/core.dart';
import 'package:subscription/subscription.dart';

class SubscriptionDetailCubit extends Cubit<DataState<SubscriptionDetailModel>> {
  SubscriptionDetailCubit(this._repository) : super(const DataInitial<SubscriptionDetailModel>());

  final SubscriptionRepository _repository;

  Future<void> load() async {
    emit(const DataLoading<SubscriptionDetailModel>());
    try {
      final detail = await _repository.getSubscription();
      emit(DataSuccess<SubscriptionDetailModel>(detail));
    } on Object catch (e) {
      emit(DataFailure<SubscriptionDetailModel>(e));
    }
  }
}
