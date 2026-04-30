import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sport_manager_mobile/features/subscription/subscription.dart';
import 'package:sport_manager_mobile/l10n/l10n.dart';
import 'package:sport_manager_mobile/ui/ui.dart';
import 'package:subscription/subscription.dart';

class SubscriptionCheckoutContent extends StatelessWidget {
  const SubscriptionCheckoutContent({
    required this.cubit,
    required this.pricing,
    super.key,
  });

  final SubscriptionCheckoutCubit cubit;
  final SubscriptionPricingModel pricing;

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.x4,
        AppSpacing.x4,
        AppSpacing.x4,
        kAppButtonFabClearance,
      ),
      children: [
        _SummaryCard(pricing),
        const SizedBox(height: AppSpacing.x6),
        Text(
          context.l10n.subscriptionCheckoutDuration,
          style: context.appTextStyles.muted.labelSmall.copyWith(
            letterSpacing: 0.6,
          ),
        ),
        const SizedBox(height: AppSpacing.x2),
        _DurationField(cubit: cubit, pricing: pricing),
        const SizedBox(height: AppSpacing.x6),
        _TotalField(cubit: cubit, pricing: pricing),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard(this.pricing);

  final SubscriptionPricingModel pricing;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.appColors.brandAmberSoft,
      borderRadius: AppRadius.cardBorderRadius,
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
    );
  }
}

class _DurationField extends StatelessWidget {
  const _DurationField({
    required this.cubit,
    required this.pricing,
  });

  final SubscriptionCheckoutCubit cubit;
  final SubscriptionPricingModel pricing;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SubscriptionCheckoutCubit, SubscriptionCheckoutState>(
      bloc: cubit,
      buildWhen: (a, b) => a.months != b.months,
      builder: (_, state) => SubscriptionDurationPicker(
        value: state.months,
        minMonths: pricing.minDurationMonths,
        maxMonths: pricing.maxDurationMonths,
        onChanged: cubit.setMonths,
      ),
    );
  }
}

class _TotalField extends StatelessWidget {
  const _TotalField({
    required this.cubit,
    required this.pricing,
  });

  final SubscriptionCheckoutCubit cubit;
  final SubscriptionPricingModel pricing;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SubscriptionCheckoutCubit, SubscriptionCheckoutState>(
      bloc: cubit,
      buildWhen: (a, b) => a.months != b.months,
      builder: (_, state) => SubscriptionTotalCard(
        months: state.months,
        monthlyAmount: pricing.monthlyAmount,
        currency: pricing.currency,
        newEndDate: state.newEndDate,
      ),
    );
  }
}
