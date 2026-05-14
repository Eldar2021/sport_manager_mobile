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
import 'package:sport_manager_mobile/l10n/l10n.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    super.initState();
    context.read<HomeCubit>().load();
  }

  Future<void> _openVenueSelector(VenueModel current) async {
    final isOwner = context.read<AuthCubit>().state.isOwner;
    final selected = await CustomSheet.open<VenueModel>(
      context: context,
      title: context.l10n.homeSelectVenue,
      emptyMessage: context.l10n.homeNoVenuesTitle,
      loader: () => GetIt.I<FacilityRepository>().getVenues(),
      titleBuilder: (_, v) => v.name,
      selectedItem: current,
      itemBuilder: (_, venue, _, onTap) {
        return VenueItem(
          venue: venue,
          isSelected: venue.id == current.id,
          onTap: onTap,
        );
      },
      footer: isOwner ? const _NewVenueFooter() : null,
      footerHeight: isOwner ? 96 : 0,
    );
    if (!mounted || selected == null) return;
    await context.read<HomeCubit>().selectVenue(selected.id);
  }

  @override
  Widget build(BuildContext context) {
    final isOwner = context.select<AuthCubit, bool>((c) => c.state.isOwner);
    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) => switch (state) {
            HomeLoaded(:final venue) || HomeNoTables(:final venue) => VenueListTile(
              venue: venue,
              onTap: () => _openVenueSelector(venue),
            ),
            _ => const SizedBox.shrink(),
          },
        ),
      ),
      body: RefreshIndicator.adaptive(
        onRefresh: () => context.read<HomeCubit>().load(),
        child: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) => switch (state) {
            HomeNoVenue() => const VenuesEmpty(),
            HomeNoTables(:final venue) => TablesEmpty(venue),
            HomeLoaded(:final venue, :final tables) => HomeSuccess(
              venue: venue,
              tables: tables,
              onTableTap: (table) => context.push(
                AppRoutes.tableDetail,
                extra: table,
              ),
            ),
            HomeLoading() => const HomeSkeleton(),
            HomeFailure(:final exception) => ErrorBodyWidget(
              exception,
              onRetryPressed: context.read<HomeCubit>().load,
            ),
          },
        ),
      ),
      floatingActionButton: isOwner
          ? BlocBuilder<HomeCubit, HomeState>(
              builder: (context, state) => switch (state) {
                HomeLoaded(:final venue) || HomeNoTables(:final venue) => FloatingActionButton(
                  onPressed: () => context.push(
                    AppRoutes.tableForm,
                    extra: TableFormExtra(venueId: venue.id),
                  ),
                  child: const Icon(Icons.add_rounded),
                ),
                _ => const SizedBox.shrink(),
              },
            )
          : null,
    );
  }
}

class _NewVenueFooter extends StatelessWidget {
  const _NewVenueFooter();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.x4,
        AppSpacing.x2,
        AppSpacing.x4,
        AppSpacing.bottom(context),
      ),
      child: AppOutlinedButton(
        title: context.l10n.homeNewVenue,
        onTap: () {
          Navigator.pop(context);
          context.push(AppRoutes.venueForm);
        },
      ),
    );
  }
}
