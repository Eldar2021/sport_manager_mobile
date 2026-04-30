import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sport_manager_mobile/app/app.dart';
import 'package:sport_manager_mobile/core/core.dart';
import 'package:sport_manager_mobile/features/subscription/subscription.dart';
import 'package:sport_manager_mobile/l10n/l10n.dart';
import 'package:sport_manager_mobile/ui/ui.dart';
import 'package:subscription/subscription.dart';

class SubscriptionContinueFab extends StatelessWidget {
  const SubscriptionContinueFab(this.cubit, {super.key});

  final SubscriptionDetailCubit cubit;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SubscriptionDetailCubit, DataState<SubscriptionDetailModel>>(
      bloc: cubit,
      buildWhen: (a, b) => a.dataValue?.subscription.alert != b.dataValue?.subscription.alert,
      builder: (_, state) {
        final subscription = state.dataValue?.subscription;
        if (subscription == null || !subscription.needsRenewal) {
          return const SizedBox.shrink();
        }
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x4),
          child: AppButton(
            collapseOnScroll: true,
            onPressed: () => context.push(AppRoutes.subscriptionCheckout),
            child: Text(context.l10n.subscriptionContinueCta),
          ),
        );
      },
    );
  }
}
