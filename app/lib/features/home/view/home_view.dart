import 'package:facility/facility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:sport_manager_mobile/app/app.dart';
import 'package:sport_manager_mobile/core/core.dart';
import 'package:sport_manager_mobile/features/auth/auth.dart';
import 'package:sport_manager_mobile/features/home/home.dart';
import 'package:sport_manager_mobile/features/tables/tables.dart';
import 'package:sport_manager_mobile/features/venues/venues.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late final HomeCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = HomeCubit(GetIt.I<FacilityRepository>());
    _cubit.load();
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  void _openVenueSelector(VenueModel venue) {
    final isOwner = context.read<AuthCubit>().state.isOwner;
    VenueSelectorSheet.show(
      context,
      selectedVenue: venue,
      onSelect: (selected) => _cubit.selectVenue(selected.id),
      isOwner: isOwner,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isOwner = context.read<AuthCubit>().state.isOwner;
    return BlocBuilder<HomeCubit, HomeState>(
      bloc: _cubit,
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: switch (state) {
              HomeLoaded(:final venue) => VenueListTile(
                venue: venue,
                onTap: () => _openVenueSelector(venue),
              ),
              _ => const SizedBox.shrink(),
            },
          ),
          body: RefreshIndicator.adaptive(
            onRefresh: () => _cubit.load(),
            child: switch (state) {
              HomeNoVenue() => const VenuesEmptyWidget(),
              HomeNoTables() => const TablesEmptyWidget(),
              HomeLoaded(:final venue, :final tables) => HomeLoadedWidget(
                venue: venue,
                tables: tables,
              ),
              HomeLoading() => const HomeLoadingWidget(),
              HomeFailure(:final exception) => ErrorBodyWidget(
                exception,
                onRetryPressed: _cubit.load,
              ),
            },
          ),
          floatingActionButton: switch (state) {
            HomeLoaded(:final venue) =>
              isOwner
                  ? FloatingActionButton(
                      onPressed: () => context.push(
                        AppRoutes.tableForm,
                        extra: TableFormExtra(venueId: venue.id),
                      ),
                      child: const Icon(Icons.add_rounded),
                    )
                  : null,
            _ => null,
          },
        );
      },
    );
  }
}
