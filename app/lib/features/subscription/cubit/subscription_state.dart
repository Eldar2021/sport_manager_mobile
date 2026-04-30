part of 'subscription_cubit.dart';

@immutable
final class SubscriptionState extends Equatable {
  const SubscriptionState({
    this.summary = const RequestInitial<SubscriptionSummaryModel>(),
  });

  final RequestStatus<SubscriptionSummaryModel> summary;

  SubscriptionSummaryModel? get data => summary.dataOrNull;

  bool get isBlocked => data?.isBlocked ?? false;

  bool get hasWarning => data?.hasWarning ?? false;

  SubscriptionState copyWith({
    RequestStatus<SubscriptionSummaryModel>? summary,
  }) {
    return SubscriptionState(
      summary: summary ?? this.summary,
    );
  }

  @override
  List<Object?> get props => [
    summary,
  ];
}
