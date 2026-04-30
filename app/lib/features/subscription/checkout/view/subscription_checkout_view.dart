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
    _cubit = SubscriptionCheckoutCubit(
      GetIt.I<SubscriptionRepository>(),
    )..loadPricing();
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
      await context.push<bool>(
        AppRoutes.subscriptionPayment,
        extra: payment,
      );
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
          buildWhen: (a, b) => a.pricing != b.pricing,
          builder: (_, state) => switch (state.pricing) {
            RequestSuccess<SubscriptionPricingModel>(:final data) when data.tableCount == 0 =>
              const SubscriptionNoTables(),
            RequestSuccess<SubscriptionPricingModel>(:final data) => SubscriptionCheckoutContent(
              cubit: _cubit,
              pricing: data,
            ),
            RequestFailure<SubscriptionPricingModel>() => SubscriptionErrorView(_cubit.loadPricing),
            _ => const SubscriptionSkeleton(),
          },
        ),
        floatingActionButtonLocation: kAppButtonFabLocation,
        floatingActionButton: SubscriptionPayFab(
          cubit: _cubit,
          onPressed: _onPay,
        ),
      ),
    );
  }
}
