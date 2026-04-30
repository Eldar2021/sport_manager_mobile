import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
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
    _cubit = SubscriptionDetailCubit(GetIt.I<SubscriptionRepository>())..load();
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
              DataSuccess<SubscriptionDetailModel>(:final data) => SubscriptionDetailContent(data),
              DataFailure<SubscriptionDetailModel>() => SubscriptionErrorView(onRetry: _cubit.load),
              _ => const SubscriptionSkeleton(),
            },
          ),
        ),
        floatingActionButtonLocation: kAppButtonFabLocation,
        floatingActionButton: SubscriptionContinueFab(cubit: _cubit),
      ),
    );
  }
}
