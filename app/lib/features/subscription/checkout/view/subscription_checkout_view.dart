import 'package:core/core.dart';
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

class SubscriptionCheckoutView extends StatefulWidget {
  const SubscriptionCheckoutView({super.key});

  @override
  State<SubscriptionCheckoutView> createState() => _SubscriptionCheckoutViewState();
}

class _SubscriptionCheckoutViewState extends State<SubscriptionCheckoutView> {
  late final SubscriptionCheckoutCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = SubscriptionCheckoutCubit(GetIt.I<SubscriptionRepository>());
    _cubit.loadPricing();
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  Future<void> _onPay() async {
    try {
      final payment = await _cubit.checkout();
      if (!mounted || payment == null) return;
      await context.push<bool>(AppRoutes.subscriptionPayment, extra: payment);
    } on Object catch (e) {
      if (mounted) context.handleError(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppButtonScope(
      child: Scaffold(
        appBar: AppBar(
          title: Text(context.l10n.subscriptionCheckoutTitle),
          actions: [
            IconButton(
              tooltip: context.l10n.contactSupportTitle,
              icon: const Icon(Icons.help_outline),
              onPressed: () => ContactSupportSheet.show(context),
            ),
          ],
        ),
        body: BlocBuilder<SubscriptionCheckoutCubit, SubscriptionCheckoutState>(
          bloc: _cubit,
          builder: (_, state) {
            return switch (state.pricing) {
              RequestInitial<SubscriptionPricingModel>() || RequestLoading<SubscriptionPricingModel>() => const Padding(
                padding: EdgeInsets.all(AppSpacing.x4),
                child: SubscriptionSkeleton(),
              ),
              RequestFailure<SubscriptionPricingModel>() => Padding(
                padding: const EdgeInsets.all(AppSpacing.x4),
                child: SubscriptionErrorView(onRetry: _cubit.loadPricing),
              ),
              RequestSuccess<SubscriptionPricingModel>(:final data) =>
                data.tableCount == 0
                    ? const SubscriptionNoTables()
                    : _Body(
                        state: state,
                        pricing: data,
                      ),
            };
          },
        ),
        floatingActionButtonLocation: kAppButtonFabLocation,
        floatingActionButton: BlocBuilder<SubscriptionCheckoutCubit, SubscriptionCheckoutState>(
          bloc: _cubit,
          builder: (_, state) {
            final pricing = state.pricing.dataOrNull;
            if (pricing == null || pricing.tableCount == 0) return const SizedBox.shrink();
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x4),
              child: AppButton(
                collapseOnScroll: true,
                isLoading: state.checkout.isLoading,
                onPressed: _onPay,
                child: Text(context.l10n.subscriptionCheckoutPay),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({
    required this.state,
    required this.pricing,
  });

  final SubscriptionCheckoutState state;
  final SubscriptionPricingModel pricing;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.x4,
        AppSpacing.x4,
        AppSpacing.x4,
        kAppButtonFabClearance,
      ),
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            color: context.appColors.brandAmberSoft,
            borderRadius: AppRadius.cardBorderRadius,
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.x4),
            child: Text(
              context.l10n.subscriptionCheckoutSummary(
                pricing.tableCount,
                pricing.pricePerTable,
                pricing.monthlyAmount,
                pricing.currency,
              ),
              style: context.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: context.colors.primary,
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.x6),
        Text(
          context.l10n.subscriptionCheckoutDuration,
          style: context.appTextStyles.muted.labelSmall.copyWith(letterSpacing: 0.6),
        ),
        const SizedBox(height: AppSpacing.x2),
        SubscriptionDurationPicker(
          value: state.months,
          minMonths: pricing.minDurationMonths,
          maxMonths: pricing.maxDurationMonths,
          onChanged: context.read<SubscriptionCheckoutCubit>().setMonths,
        ),
        const SizedBox(height: AppSpacing.x6),
        SubscriptionTotalCard(
          months: state.months,
          monthlyAmount: pricing.monthlyAmount,
          currency: pricing.currency,
          newEndDate: state.newEndDate,
        ),
      ],
    );
  }
}
