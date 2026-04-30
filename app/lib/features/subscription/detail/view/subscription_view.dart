import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:sport_manager_mobile/app/app.dart';
import 'package:sport_manager_mobile/core/core.dart';
import 'package:sport_manager_mobile/features/subscription/subscription.dart';
import 'package:sport_manager_mobile/l10n/l10n.dart';
import 'package:sport_manager_mobile/ui/ui.dart';
import 'package:subscription/subscription.dart';

class SubscriptionView extends StatefulWidget {
  const SubscriptionView({super.key});

  @override
  State<SubscriptionView> createState() => _SubscriptionViewState();
}

class _SubscriptionViewState extends State<SubscriptionView> {
  late final SubscriptionDetailCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = SubscriptionDetailCubit(GetIt.I<SubscriptionRepository>());
    _cubit.load();
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppButtonScope(
      child: Scaffold(
        appBar: AppBar(
          title: Text(context.l10n.subscriptionTitle),
          actions: [
            IconButton(
              tooltip: context.l10n.contactSupportTitle,
              icon: const Icon(Icons.help_outline),
              onPressed: () => ContactSupportSheet.show(context),
            ),
          ],
        ),
        body: RefreshIndicator.adaptive(
          onRefresh: _cubit.load,
          child: BlocBuilder<SubscriptionDetailCubit, DataState<SubscriptionDetailModel>>(
            bloc: _cubit,
            builder: (_, state) => switch (state) {
              DataLoading<SubscriptionDetailModel>() || DataInitial<SubscriptionDetailModel>() => ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(AppSpacing.x4),
                children: const [SubscriptionSkeleton()],
              ),
              DataFailure<SubscriptionDetailModel>() => ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(AppSpacing.x4),
                children: [SubscriptionErrorView(onRetry: _cubit.load)],
              ),
              DataSuccess<SubscriptionDetailModel>(:final data) => _Content(detail: data),
            },
          ),
        ),
        floatingActionButtonLocation: kAppButtonFabLocation,
        floatingActionButton: BlocBuilder<SubscriptionDetailCubit, DataState<SubscriptionDetailModel>>(
          bloc: _cubit,
          builder: (_, state) {
            final detail = state.dataValue;
            if (detail == null) return const SizedBox.shrink();
            final s = detail.subscription;
            final showFab =
                s.status == SubscriptionStatus.expired ||
                s.status == SubscriptionStatus.grace ||
                (s.status == SubscriptionStatus.active && s.daysUntilExpiry <= 3);
            if (!showFab) return const SizedBox.shrink();
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x4),
              child: AppButton(
                collapseOnScroll: true,
                onPressed: () => context.push(AppRoutes.subscriptionCheckout),
                child: Text(context.l10n.subscriptionContinueCta),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content({required this.detail});

  final SubscriptionDetailModel detail;

  @override
  Widget build(BuildContext context) {
    final s = detail.subscription;
    final lastPaid = detail.payments.where((p) => p.status == PaymentStatus.paid).firstOrNull;
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.x4,
        AppSpacing.x4,
        AppSpacing.x4,
        kAppButtonFabClearance,
      ),
      children: [
        SubscriptionStatusBanner(s),
        if (s.status != SubscriptionStatus.active || s.daysUntilExpiry <= 3) const SizedBox(height: AppSpacing.x4),
        SubscriptionPlanCard(
          subscription: s,
          pricePerTable: lastPaid?.pricePerTableSnapshot ?? 0,
          tableCount: lastPaid?.tableCountSnapshot ?? 0,
          currency: lastPaid?.currency ?? 'KGS',
        ),
        const SizedBox(height: AppSpacing.x4),
        SubscriptionDetailRows(subscription: s, lastPayment: lastPaid),
        const SizedBox(height: AppSpacing.x6),
        Text(
          context.l10n.subscriptionPaymentHistoryTitle,
          style: context.appTextStyles.muted.labelSmall.copyWith(letterSpacing: 0.6),
        ),
        const SizedBox(height: AppSpacing.x2),
        SubscriptionPaymentHistory(payments: detail.payments),
      ],
    );
  }
}
