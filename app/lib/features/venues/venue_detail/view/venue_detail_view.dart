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
  Widget build(BuildContext context) {
    return AppButtonScope(
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.venue.name),
          actions: [
            IconButton(
              icon: const Icon(Icons.more_vert_rounded),
              onPressed: () => context.push(
                AppRoutes.venueForm,
                extra: widget.venue,
              ),
            ),
            const SizedBox(width: AppSpacing.x2),
          ],
        ),
        body: RefreshIndicator.adaptive(
          onRefresh: _cubit.load,
          child: ListView(
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
                tableCount: widget.venue.tableCount,
              ),
              const SizedBox(height: AppSpacing.x4),
              BlocConsumer<VenueDetailCubit, DataState<List<TableModel>>>(
                bloc: _cubit,
                listenWhen: (prev, next) => next is DataFailure<List<TableModel>>,
                listener: (context, state) {
                  if (state is DataFailure<List<TableModel>>) {
                    context.handleError(state.exception);
                  }
                },
                builder: (context, state) {
                  return switch (state) {
                    DataInitial<List<TableModel>>() ||
                    DataLoading<List<TableModel>>() ||
                    DataFailure<List<TableModel>>() => const TablesSection(
                      count: null,
                      child: VenueDetailSkeleton(),
                    ),
                    DataSuccess<List<TableModel>>(:final data) => TablesSection(
                      count: data.length,
                      child: data.isEmpty
                          ? const Padding(
                              padding: EdgeInsets.symmetric(vertical: AppSpacing.x10),
                              child: TablesEmptyView(),
                            )
                          : TablesList(
                              tables: data,
                              venueId: widget.venue.id,
                            ),
                    ),
                  };
                },
              ),
            ],
          ),
        ),
        floatingActionButtonLocation: kAppButtonFabLocation,
        floatingActionButton: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x6),
          child: AppButton(
            leading: const Icon(Icons.add_rounded),
            onPressed: _onAddTable,
            child: Text(context.l10n.homeAddTable),
          ),
        ),
      ),
    );
  }

  Future<void> _onAddTable() async {
    final value = await context.push<bool>(
      AppRoutes.tableForm,
      extra: TableFormExtra(venueId: widget.venue.id),
    );
    if (value == true) {
      await _cubit.load();
    }
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }
}
