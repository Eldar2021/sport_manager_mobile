import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:sport_manager_mobile/core/core.dart';
import 'package:sport_manager_mobile/features/subscription/cubit/subscription_cubit.dart';
import 'package:sport_manager_mobile/features/subscription/payment/cubit/subscription_payment_cubit.dart';
import 'package:sport_manager_mobile/features/subscription/payment/widgets/subscription_payment_outcome.dart';
import 'package:sport_manager_mobile/features/subscription/payment/widgets/subscription_payment_pending.dart';
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
    _cubit = SubscriptionPaymentCubit(GetIt.I<SubscriptionRepository>(), widget.payment);
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

  void _onClose() {
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
            PaymentStatus.pending => SubscriptionPaymentPending(payment: payment, onConfirm: _onConfirm),
            PaymentStatus.paid => SubscriptionPaymentOutcome.success(
              context,
              body: context.l10n.subscriptionPaymentSuccessBody(_extendedDate(context, payment)),
              onClose: _onClose,
            ),
            PaymentStatus.failed => SubscriptionPaymentOutcome.failed(
              context,
              onRetry: () => Navigator.of(context).pop(),
            ),
          };
        },
      ),
    );
  }

  String _extendedDate(BuildContext context, PaymentModel payment) {
    final paidAt = payment.paidAt ?? DateTime.now();
    final newEnd = paidAt.add(Duration(days: payment.months * 30)).toLocal();
    return DateFormat('d MMMM yyyy', Localizations.localeOf(context).languageCode).format(newEnd);
  }
}
