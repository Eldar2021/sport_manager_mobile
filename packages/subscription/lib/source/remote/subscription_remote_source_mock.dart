import 'package:subscription/exceptions/subscription_exception.dart';
import 'package:subscription/models/checkout_param.dart';
import 'package:subscription/models/payment_model.dart';
import 'package:subscription/models/payment_outcome.dart';
import 'package:subscription/models/payment_status.dart';
import 'package:subscription/models/subscription_detail_model.dart';
import 'package:subscription/models/subscription_model.dart';
import 'package:subscription/models/subscription_pricing_model.dart';
import 'package:subscription/models/subscription_source.dart';
import 'package:subscription/models/subscription_status.dart';
import 'package:subscription/source/remote/subscription_remote_source.dart';

/// Dev/preview mock for the subscription endpoints.
///
/// Maintains a single in-memory subscription + payments list. Supports four
/// preset scenarios (`MockSubscriptionScenario`) the dev tools can switch
/// between to exercise the UI's status-driven branches.
enum MockSubscriptionScenario {
  activeFar,
  activeWarning,
  graceMidway,
  expired,
}

final class SubscriptionRemoteSourceMock implements SubscriptionRemoteSource {
  SubscriptionRemoteSourceMock({
    MockSubscriptionScenario scenario = MockSubscriptionScenario.activeFar,
  }) {
    setScenario(scenario);
  }

  static const _ownerId = 'user-001';
  static const _subscriptionId = 'sub-001';
  static const _pricePerTable = 200;
  static const _currency = 'KGS';
  static const _tableCount = 10;
  static const _gracePeriodDays = 5;
  static const _freeTrialDays = 14;
  static const _expiryWarningDays = 3;
  static const _minDurationMonths = 1;
  static const _maxDurationMonths = 12;

  late SubscriptionModel _subscription;
  final List<PaymentModel> _payments = <PaymentModel>[];
  int _paymentSeq = 100;

  void setScenario(MockSubscriptionScenario scenario) {
    final now = DateTime.now().toUtc();
    _payments
      ..clear()
      ..addAll(_seedPayments(now));
    _subscription = switch (scenario) {
      MockSubscriptionScenario.activeFar => _build(
        status: SubscriptionStatus.active,
        startDate: now.subtract(const Duration(days: 15)),
        endDate: now.add(const Duration(days: 15)),
        gracePeriodEndsAt: null,
        daysUntilExpiry: 15,
        graceDaysRemaining: 0,
        now: now,
      ),
      MockSubscriptionScenario.activeWarning => _build(
        status: SubscriptionStatus.active,
        startDate: now.subtract(const Duration(days: 27)),
        endDate: now.add(const Duration(days: 3)),
        gracePeriodEndsAt: null,
        daysUntilExpiry: 3,
        graceDaysRemaining: 0,
        now: now,
      ),
      MockSubscriptionScenario.graceMidway => _build(
        status: SubscriptionStatus.grace,
        startDate: now.subtract(const Duration(days: 32)),
        endDate: now.subtract(const Duration(days: 2)),
        gracePeriodEndsAt: now.add(const Duration(days: 3)),
        daysUntilExpiry: 0,
        graceDaysRemaining: 3,
        now: now,
      ),
      MockSubscriptionScenario.expired => _build(
        status: SubscriptionStatus.expired,
        startDate: now.subtract(const Duration(days: 40)),
        endDate: now.subtract(const Duration(days: 10)),
        gracePeriodEndsAt: now.subtract(const Duration(days: 5)),
        daysUntilExpiry: 0,
        graceDaysRemaining: 0,
        now: now,
      ),
    };
  }

  @override
  Future<SubscriptionDetailModel> getSubscription() async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    return SubscriptionDetailModel(
      subscription: _subscription,
      payments: List.unmodifiable(_payments.reversed),
    );
  }

  @override
  Future<SubscriptionPricingModel> getPricing() async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return const SubscriptionPricingModel(
      pricePerTable: _pricePerTable,
      currency: _currency,
      tableCount: _tableCount,
      monthlyAmount: _pricePerTable * _tableCount,
      minDurationMonths: _minDurationMonths,
      maxDurationMonths: _maxDurationMonths,
      gracePeriodDays: _gracePeriodDays,
      freeTrialDays: _freeTrialDays,
      expiryWarningDays: _expiryWarningDays,
    );
  }

  @override
  Future<PaymentModel> createCheckout(CheckoutParam param) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    if (param.months < _minDurationMonths || param.months > _maxDurationMonths) {
      throw const SubscriptionException(SubscriptionErrorCode.invalidDuration);
    }
    if (_tableCount == 0) {
      throw const SubscriptionException(SubscriptionErrorCode.noTables);
    }
    final now = DateTime.now().toUtc();
    final payment = PaymentModel(
      id: _nextPaymentId(),
      subscriptionId: _subscriptionId,
      amount: _pricePerTable * _tableCount * param.months,
      currency: _currency,
      months: param.months,
      tableCountSnapshot: _tableCount,
      pricePerTableSnapshot: _pricePerTable,
      status: PaymentStatus.pending,
      provider: 'MOCK',
      createdAt: now,
    );
    _payments.add(payment);
    return payment;
  }

  @override
  Future<PaymentModel> getPayment(String id) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    final payment = _payments.where((p) => p.id == id).firstOrNull;
    if (payment == null) {
      throw const SubscriptionException(SubscriptionErrorCode.paymentNotFound);
    }
    return payment;
  }

  @override
  Future<PaymentModel> confirmMockPayment(
    String id,
    PaymentOutcome outcome,
  ) async {
    await Future<void>.delayed(const Duration(milliseconds: 700));
    final index = _payments.indexWhere((p) => p.id == id);
    if (index == -1) {
      throw const SubscriptionException(SubscriptionErrorCode.paymentNotFound);
    }
    final existing = _payments[index];
    if (existing.status != PaymentStatus.pending) {
      throw const SubscriptionException(SubscriptionErrorCode.paymentAlreadyProcessed);
    }
    final now = DateTime.now().toUtc();
    final updated = PaymentModel(
      id: existing.id,
      subscriptionId: existing.subscriptionId,
      amount: existing.amount,
      currency: existing.currency,
      months: existing.months,
      tableCountSnapshot: existing.tableCountSnapshot,
      pricePerTableSnapshot: existing.pricePerTableSnapshot,
      status: outcome == PaymentOutcome.paid ? PaymentStatus.paid : PaymentStatus.failed,
      provider: existing.provider,
      providerPaymentId: existing.providerPaymentId,
      paymentUrl: existing.paymentUrl,
      createdAt: existing.createdAt,
      paidAt: outcome == PaymentOutcome.paid ? now : null,
      failedAt: outcome == PaymentOutcome.failed ? now : null,
      failureReason: outcome == PaymentOutcome.failed ? 'Simulated failure' : null,
    );
    _payments[index] = updated;

    if (outcome == PaymentOutcome.paid) {
      _extendSubscription(months: existing.months, now: now);
    }
    return updated;
  }

  void _extendSubscription({
    required int months,
    required DateTime now,
  }) {
    final extensionDays = months * 30;
    final basis = _subscription.endDate.isAfter(now) ? _subscription.endDate : now;
    final newEnd = basis.add(Duration(days: extensionDays));
    _subscription = _build(
      status: SubscriptionStatus.active,
      startDate: _subscription.endDate.isAfter(now) ? _subscription.startDate : now,
      endDate: newEnd,
      gracePeriodEndsAt: null,
      daysUntilExpiry: newEnd.difference(now).inDays,
      graceDaysRemaining: 0,
      now: now,
    );
  }

  SubscriptionModel _build({
    required SubscriptionStatus status,
    required DateTime startDate,
    required DateTime endDate,
    required DateTime? gracePeriodEndsAt,
    required int daysUntilExpiry,
    required int graceDaysRemaining,
    required DateTime now,
    SubscriptionSource source = SubscriptionSource.paid,
  }) {
    return SubscriptionModel(
      id: _subscriptionId,
      ownerId: _ownerId,
      status: status,
      source: source,
      startDate: startDate,
      endDate: endDate,
      gracePeriodEndsAt: gracePeriodEndsAt,
      daysUntilExpiry: daysUntilExpiry,
      graceDaysRemaining: graceDaysRemaining,
      createdAt: startDate,
      updatedAt: now,
    );
  }

  String _nextPaymentId() => 'pay-${_paymentSeq++}';

  List<PaymentModel> _seedPayments(DateTime now) {
    final twoMonthsAgo = now.subtract(const Duration(days: 60));
    final oneMonthAgo = now.subtract(const Duration(days: 30));
    return <PaymentModel>[
      PaymentModel(
        id: 'pay-1',
        subscriptionId: _subscriptionId,
        amount: _pricePerTable * _tableCount,
        currency: _currency,
        months: 1,
        tableCountSnapshot: _tableCount,
        pricePerTableSnapshot: _pricePerTable,
        status: PaymentStatus.paid,
        provider: 'MOCK',
        createdAt: twoMonthsAgo,
        paidAt: twoMonthsAgo,
      ),
      PaymentModel(
        id: 'pay-2',
        subscriptionId: _subscriptionId,
        amount: _pricePerTable * _tableCount,
        currency: _currency,
        months: 1,
        tableCountSnapshot: _tableCount,
        pricePerTableSnapshot: _pricePerTable,
        status: PaymentStatus.paid,
        provider: 'MOCK',
        createdAt: oneMonthAgo,
        paidAt: oneMonthAgo,
      ),
    ];
  }
}
