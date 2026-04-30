import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sport_manager_mobile/features/subscription/subscription.dart';
import 'package:sport_manager_mobile/l10n/l10n.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

class SubscriptionPayFab extends StatelessWidget {
  const SubscriptionPayFab({
    required this.cubit,
    required this.onPressed,
    super.key,
  });

  final SubscriptionCheckoutCubit cubit;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SubscriptionCheckoutCubit, SubscriptionCheckoutState>(
      bloc: cubit,
      buildWhen: (a, b) => a.checkout.isLoading != b.checkout.isLoading || a.pricing != b.pricing,
      builder: (_, state) {
        final pricing = state.pricing.dataOrNull;
        if (pricing == null || pricing.tableCount == 0) {
          return const SizedBox.shrink();
        }
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x4),
          child: AppButton(
            collapseOnScroll: true,
            isLoading: state.checkout.isLoading,
            onPressed: onPressed,
            child: Text(context.l10n.subscriptionCheckoutPay),
          ),
        );
      },
    );
  }
}
