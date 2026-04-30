import 'package:facility/facility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:sport_manager_mobile/app/app.dart';
import 'package:sport_manager_mobile/core/core.dart';
import 'package:sport_manager_mobile/features/tables/tables.dart';
import 'package:sport_manager_mobile/features/venues/venues.dart';
import 'package:sport_manager_mobile/l10n/l10n.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

class VenueDetailView extends StatefulWidget {
  const VenueDetailView({required this.venue, super.key});

  final VenueModel venue;

  @override
  State<VenueDetailView> createState() => _VenueDetailViewState();
}

class _VenueDetailViewState extends State<VenueDetailView> {
  late final VenueDetailCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = VenueDetailCubit(
      repository: GetIt.I<FacilityRepository>(),
      venueId: widget.venue.id,
    );
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
          title: Text(widget.venue.name),
          actions: [
            IconButton(
              onPressed: () => context.push(AppRoutes.venueForm, extra: widget.venue),
              icon: const Icon(Icons.more_vert_rounded),
            ),
            const SizedBox(width: AppSpacing.x2),
          ],
        ),
        body: RefreshIndicator.adaptive(
          onRefresh: _cubit.load,
          child: BlocConsumer<VenueDetailCubit, DataState<List<TableModel>>>(
            bloc: _cubit,
            listenWhen: (prev, next) => next is DataFailure<List<TableModel>>,
            listener: (context, state) {
              if (state is DataFailure<List<TableModel>>) {
                context.handleError(state.exception);
              }
            },
            builder: (context, state) {
              return ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.x4,
                  AppSpacing.x4,
                  AppSpacing.x4,
                  kAppButtonFabClearance,
                ),
                children: [
                  VenueDetailHeaderCard(
                    venue: widget.venue,
                    tableCount: switch (state) {
                      DataSuccess<List<TableModel>>(:final data) => data.length,
                      _ => widget.venue.tableCount,
                    },
                  ),
                  const SizedBox(height: AppSpacing.x4),
                  switch (state) {
                    DataInitial<List<TableModel>>() ||
                    DataLoading<List<TableModel>>() ||
                    DataFailure<List<TableModel>>() => const _TablesSection(
                      count: null,
                      child: VenueDetailSkeleton(),
                    ),
                    DataSuccess<List<TableModel>>(:final data) => _TablesSection(
                      count: data.length,
                      child: data.isEmpty
                          ? const Padding(
                              padding: EdgeInsets.symmetric(vertical: AppSpacing.x10),
                              child: TablesEmptyView(),
                            )
                          : _TablesList(tables: data, venueId: widget.venue.id),
                    ),
                  },
                ],
              );
            },
          ),
        ),
        floatingActionButtonLocation: kAppButtonFabLocation,
        floatingActionButton: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x6),
          child: AppButton(
            leading: const Icon(Icons.add_rounded),
            onPressed: () => context.push(
              AppRoutes.tableForm,
              extra: TableFormExtra(venueId: widget.venue.id),
            ),
            child: Text(context.l10n.homeAddTable),
          ),
        ),
      ),
    );
  }
}

class _TablesSection extends StatelessWidget {
  const _TablesSection({required this.count, required this.child});

  final int? count;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.x2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.x4,
                AppSpacing.x2,
                AppSpacing.x4,
                AppSpacing.x2,
              ),
              child: Row(
                children: [
                  Text(
                    context.l10n.venueDetailTablesHeader,
                    style: context.textTheme.bodySmall?.copyWith(
                      color: context.colors.onSurfaceVariant,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const Spacer(),
                  if (count != null)
                    Text(
                      context.l10n.venueTablesCountSuffix(count!),
                      style: context.appTextStyles.muted.bodySmall,
                    ),
                ],
              ),
            ),
            const Divider(height: 1),
            child,
          ],
        ),
      ),
    );
  }
}

class _TablesList extends StatelessWidget {
  const _TablesList({required this.tables, required this.venueId});

  final List<TableModel> tables;
  final String venueId;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      itemCount: tables.length,
      separatorBuilder: (_, _) => const Divider(height: 1),
      itemBuilder: (_, index) {
        final table = tables[index];
        return VenueTableTile(
          key: ValueKey(table.id),
          table: table,
          onTap: () => context.push(
            AppRoutes.tableForm,
            extra: TableFormExtra(venueId: venueId, table: table),
          ),
        );
      },
    );
  }
}

class TablesEmptyView extends StatelessWidget {
  const TablesEmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x6),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.table_restaurant_outlined,
            color: context.colors.onSurfaceVariant,
            size: AppSpacing.x10,
          ),
          const SizedBox(height: AppSpacing.x3),
          Text(
            context.l10n.homeTablesEmpty,
            style: context.textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            context.l10n.homeTablesEmptySub,
            style: context.appTextStyles.muted.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
