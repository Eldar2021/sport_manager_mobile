import 'dart:async';

import 'package:facility/facility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:sport_manager_mobile/app/app.dart';
import 'package:sport_manager_mobile/core/core.dart';
import 'package:sport_manager_mobile/features/auth/auth.dart';
import 'package:sport_manager_mobile/features/venues/venues.dart';
import 'package:sport_manager_mobile/l10n/l10n.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

class VenuesListView extends StatefulWidget {
  const VenuesListView({super.key});

  @override
  State<VenuesListView> createState() => _VenuesListViewState();
}

class _VenuesListViewState extends State<VenuesListView> {
  late final VenuesListCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = VenuesListCubit(GetIt.I<FacilityRepository>());
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
          title: Text(context.l10n.profileManageVenuesTitle),
        ),
        body: RefreshIndicator.adaptive(
          onRefresh: _cubit.load,
          child: BlocBuilder<VenuesListCubit, DataState<List<VenueModel>>>(
            bloc: _cubit,
            builder: (context, state) {
              return switch (state) {
                DataInitial<List<VenueModel>>() || DataLoading<List<VenueModel>>() => const VenuesListSkeleton(),
                DataFailure<List<VenueModel>>(:final exception) => ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    vertical: MediaQuery.sizeOf(context).height * 0.1,
                  ),
                  children: [
                    ErrorBodyWidget(
                      exception,
                      onRetryPressed: _cubit.load,
                    ),
                  ],
                ),
                DataSuccess<List<VenueModel>>(:final data) when data.isEmpty => ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    vertical: MediaQuery.sizeOf(context).height * 0.1,
                  ),
                  children: const [VenuesListEmpty()],
                ),
                DataSuccess<List<VenueModel>>(:final data) => ListView.separated(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.x4,
                    AppSpacing.x4,
                    AppSpacing.x4,
                    kAppButtonFabClearance,
                  ),
                  itemCount: data.length,
                  separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.x3),
                  itemBuilder: (_, index) {
                    final venue = data[index];
                    return VenueCard(
                      key: ValueKey(venue.id),
                      venue: venue,
                      onTap: () => _onNavigateDetail(venue),
                    );
                  },
                ),
              };
            },
          ),
        ),
        floatingActionButtonLocation: kAppButtonFabLocation,
        floatingActionButton: context.select<AuthCubit, bool>((c) => c.state.isOwner)
            ? BlocBuilder<VenuesListCubit, DataState<List<VenueModel>>>(
                bloc: _cubit,
                builder: (context, state) {
                  final hasVenues = state is DataSuccess<List<VenueModel>> && state.data.isNotEmpty;
                  if (!hasVenues) return const SizedBox.shrink();
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x4),
                    child: AppButton(
                      leading: const Icon(Icons.add_rounded),
                      onPressed: _onAddVenue,
                      child: Text(context.l10n.homeNewVenue),
                    ),
                  );
                },
              )
            : null,
      ),
    );
  }

  Future<void> _onNavigateDetail(VenueModel venue) async {
    final deleted = await context.push<bool>(
      AppRoutes.venueDetail,
      extra: venue,
    );
    if (deleted == true) unawaited(_cubit.load());
  }

  Future<void> _onAddVenue() async {
    final created = await context.push<VenueModel>(AppRoutes.venueForm);
    if (created != null) unawaited(_cubit.load());
  }
}
