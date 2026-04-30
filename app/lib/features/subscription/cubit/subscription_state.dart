part of 'subscription_cubit.dart';

@immutable
final class SubscriptionState extends Equatable {
  const SubscriptionState({
    this.summary = const RequestInitial<SubscriptionSummaryModel>(),
  });

  final RequestStatus<SubscriptionSummaryModel> summary;

  SubscriptionSummaryModel? get data => summary.dataOrNull;

  SubscriptionAlert get alert => data?.alert ?? SubscriptionAlert.none;

  bool get isBlocked => alert == SubscriptionAlert.expired;

  bool get needsRenewal => alert != SubscriptionAlert.none;

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
