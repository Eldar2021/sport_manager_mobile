/// Single, derived flag telling the UI which alert (if any) the current
/// subscription should display. Computed from `SubscriptionModel.alert`.
enum SubscriptionAlert {
  /// No banner / button — subscription is healthy.
  none,

  /// Active, ≤ 3 days until expiry. Soft warning, features still work.
  warning,

  /// In grace period (already past `endDate`, but features still work).
  grace,

  /// Grace ran out or status is `EXPIRED`. Core features blocked.
  expired,
}
