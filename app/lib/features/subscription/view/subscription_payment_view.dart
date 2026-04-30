import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:sport_manager_mobile/core/core.dart';
import 'package:sport_manager_mobile/features/subscription/subscription.dart';
import 'package:sport_manager_mobile/l10n/l10n.dart';
import 'package:sport_manager_mobile/ui/ui.dart';
import 'package:subscription/subscription.dart';

class SubscriptionPaymentView extends StatefulWidget {
  const SubscriptionPaymentView({required this.payment, super.key});

  final PaymentModel payment;

  @override
  State<SubscriptionPaymentView> createState() => _SubscriptionPaymentViewState();
}

class _SubscriptionPaymentViewState extends State<SubscriptionPaymentView> {
  late final SubscriptionPaymentCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = SubscriptionPaymentCubit(
      GetIt.I<SubscriptionRepository>(),
      widget.payment,
    );
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  Future<void> _onConfirm(PaymentOutcome outcome) async {
    await _cubit.confirmMock(outcome);
    if (!mounted) return;
    if (outcome == PaymentOutcome.paid && _cubit.state is DataSuccess<PaymentModel>) {
      await context.read<SubscriptionCubit>().refresh();
    }
  }

  Future<void> _onClose() async {
    if (!mounted) return;
    context
      ..pop()
      ..pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.subscriptionPaymentMockTitle),
        actions: [
          IconButton(
            tooltip: context.l10n.contactSupportTitle,
            icon: const Icon(Icons.help_outline),
            onPressed: () => ContactSupportSheet.show(context),
          ),
        ],
      ),
      body: BlocBuilder<SubscriptionPaymentCubit, DataState<PaymentModel>>(
        bloc: _cubit,
        builder: (_, state) {
          if (state is DataLoading<PaymentModel>) {
            return const Center(child: AppActivityIndicator());
          }
          final payment = state.dataValue ?? widget.payment;
          return switch (payment.status) {
            PaymentStatus.pending => _PendingBody(payment: payment, onConfirm: _onConfirm),
            PaymentStatus.paid => _SuccessBody(payment: payment, onClose: _onClose),
            PaymentStatus.failed => _FailedBody(onRetry: () => Navigator.of(context).pop()),
          };
        },
      ),
    );
  }
}

class _PendingBody extends StatelessWidget {
  const _PendingBody({
    required this.payment,
    required this.onConfirm,
  });

  final PaymentModel payment;
  final ValueChanged<PaymentOutcome> onConfirm;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              color: context.appColors.brandAmberSoft,
              borderRadius: AppRadius.cardBorderRadius,
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.x5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.l10n.subscriptionPaymentMockSubtitle,
                    style: context.appTextStyles.muted.bodyMedium,
                  ),
                  const SizedBox(height: AppSpacing.x4),
                  Text(
                    context.l10n.subscriptionAmountWithCurrency(
                      payment.amount,
                      payment.currency,
                    ),
                    style: context.textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: context.colors.primary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.x2),
                  Text(
                    context.l10n.subscriptionPaymentItemSummary(
                      payment.months,
                      payment.tableCountSnapshot,
                    ),
                    style: context.appTextStyles.muted.bodySmall,
                  ),
                ],
              ),
            ),
          ),
          const Spacer(),
          AppButton(
            onPressed: () => onConfirm(PaymentOutcome.paid),
            child: Text(context.l10n.subscriptionPaymentSimulateSuccess),
          ),
          const SizedBox(height: AppSpacing.x3),
          AppButton(
            variant: AppButtonVariant.outline,
            onPressed: () => onConfirm(PaymentOutcome.failed),
            child: Text(context.l10n.subscriptionPaymentSimulateFailure),
          ),
        ],
      ),
    );
  }
}

class _SuccessBody extends StatelessWidget {
  const _SuccessBody({
    required this.payment,
    required this.onClose,
  });

  final PaymentModel payment;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    final dateStr = DateFormat('d MMMM yyyy', locale).format(
      (payment.paidAt ?? DateTime.now()).add(Duration(days: payment.months * 30)).toLocal(),
    );
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        children: [
          const Spacer(),
          DecoratedBox(
            decoration: BoxDecoration(
              color: context.appColors.success.withValues(
                alpha: AppOpacity.tint,
              ),
              shape: BoxShape.circle,
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.x4),
              child: Icon(
                Icons.check_circle,
                size: 64,
                color: context.appColors.success,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.x4),
          Text(
            context.l10n.subscriptionPaymentSuccessTitle,
            style: context.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.x2),
          Text(
            context.l10n.subscriptionPaymentSuccessBody(dateStr),
            style: context.appTextStyles.muted.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const Spacer(),
          AppButton(
            onPressed: onClose,
            child: Text(context.l10n.subscriptionPaymentClose),
          ),
        ],
      ),
    );
  }
}

class _FailedBody extends StatelessWidget {
  const _FailedBody({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        children: [
          const Spacer(),
          DecoratedBox(
            decoration: BoxDecoration(
              color: context.colors.error.withValues(alpha: AppOpacity.tint),
              shape: BoxShape.circle,
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.x4),
              child: Icon(Icons.cancel, size: 64, color: context.colors.error),
            ),
          ),
          const SizedBox(height: AppSpacing.x4),
          Text(
            context.l10n.subscriptionPaymentFailedTitle,
            style: context.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.x2),
          Text(
            context.l10n.subscriptionPaymentFailedBody,
            style: context.appTextStyles.muted.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const Spacer(),
          AppButton(
            onPressed: onRetry,
            child: Text(context.l10n.subscriptionPaymentRetry),
          ),
        ],
      ),
    );
  }
}
