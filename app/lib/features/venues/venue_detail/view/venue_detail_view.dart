import 'package:core/core.dart';
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
  late VenueModel _venue;

  @override
  void initState() {
    super.initState();
    _venue = widget.venue;
    _cubit = VenueDetailCubit(
      repository: GetIt.I<FacilityRepository>(),
      venueId: _venue.id,
    );
    _cubit.load();
  }

  @override
  Widget build(BuildContext context) {
    return AppButtonScope(
      child: Scaffold(
        appBar: AppBar(
          title: Text(_venue.name),
          actions: [
            AppEditDeleteMenu(
              onEdit: _onEdit,
              onDelete: _onDelete,
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
                venue: _venue,
                tableCount: _venue.tableCount,
              ),
              const SizedBox(height: AppSpacing.x4),
              BlocBuilder<VenueDetailCubit, VenueDetailState>(
                bloc: _cubit,
                buildWhen: (prev, next) => prev.tables != next.tables,
                builder: (context, state) {
                  return switch (state.tables) {
                    RequestInitial<List<TableModel>>() || RequestLoading<List<TableModel>>() => const TablesSection(
                      count: null,
                      child: VenueDetailSkeleton(),
                    ),
                    RequestFailure<List<TableModel>>(:final exception) => TablesSection(
                      count: null,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: AppSpacing.x6),
                        child: ErrorBodyWidget(
                          exception,
                          onRetryPressed: _cubit.load,
                        ),
                      ),
                    ),
                    RequestSuccess<List<TableModel>>(:final data) => TablesSection(
                      count: data.length,
                      child: data.isEmpty
                          ? const Padding(
                              padding: EdgeInsets.symmetric(vertical: AppSpacing.x10),
                              child: TablesEmptyView(),
                            )
                          : TablesList(
                              tables: data,
                              venueId: _venue.id,
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
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x4),
          child: AppButton(
            leading: const Icon(Icons.add_rounded),
            onPressed: _onAddTable,
            child: Text(context.l10n.homeAddTable),
          ),
        ),
      ),
    );
  }

  Future<void> _onEdit() async {
    final updated = await context.push<VenueModel>(
      AppRoutes.venueForm,
      extra: _venue,
    );
    if (mounted && updated != null) {
      setState(() => _venue = updated);
    }
  }

  Future<void> _onDelete() async {
    await AppDestructiveSheet.show(
      context,
      icon: Icons.delete_outline_rounded,
      title: context.l10n.deleteVenueButton,
      subtitle: context.l10n.deleteVenueSubtitle,
      confirmLabel: context.l10n.deleteVenueButton,
      onConfirm: _cubit.deleteVenue,
    );
    if (!mounted) return;
    final status = _cubit.state.deleteStatus;
    if (status is RequestSuccess<bool>) {
      context.pop(true);
    } else if (status is RequestFailure<bool>) {
      context.handleError(status.exception);
    }
  }

  Future<void> _onAddTable() async {
    final value = await context.push<bool>(
      AppRoutes.tableForm,
      extra: TableFormExtra(venueId: _venue.id),
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
