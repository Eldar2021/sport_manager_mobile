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

enum _VenueAction { edit, delete }

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
      child: BlocListener<VenueDetailCubit, VenueDetailState>(
        bloc: _cubit,
        listenWhen: (prev, next) => prev.deleteStatus != next.deleteStatus,
        listener: (context, state) {
          if (state.deleteStatus is RequestSuccess<bool>) {
            context.pop(true);
          } else if (state.deleteStatus is RequestFailure<bool>) {
            context.handleError((state.deleteStatus as RequestFailure<bool>).exception);
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(widget.venue.name),
            actions: [
              PopupMenuButton<_VenueAction>(
                icon: const Icon(Icons.more_vert_rounded),
                onSelected: _onActionSelected,
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: _VenueAction.edit,
                    child: _MenuRow(
                      icon: Icons.edit_outlined,
                      color: context.colors.primary,
                      label: context.l10n.menuEdit,
                    ),
                  ),
                  PopupMenuItem(
                    value: _VenueAction.delete,
                    child: _MenuRow(
                      icon: Icons.delete_outline_rounded,
                      color: context.colors.error,
                      label: context.l10n.menuDelete,
                    ),
                  ),
                ],
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
      ),
    );
  }

  void _onActionSelected(_VenueAction action) {
    switch (action) {
      case _VenueAction.edit:
        context.push(AppRoutes.venueForm, extra: widget.venue);
      case _VenueAction.delete:
        AppDestructiveSheet.show(
          context,
          icon: Icons.delete_outline_rounded,
          title: context.l10n.deleteVenueButton,
          subtitle: context.l10n.deleteVenueSubtitle,
          confirmLabel: context.l10n.deleteVenueButton,
          onConfirm: _cubit.deleteVenue,
        );
    }
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

class _MenuRow extends StatelessWidget {
  const _MenuRow({
    required this.icon,
    required this.color,
    required this.label,
  });

  final IconData icon;
  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: color, size: AppSpacing.x5),
        const SizedBox(width: AppSpacing.x3),
        Text(
          label,
          style: context.textTheme.bodyLarge?.copyWith(color: color),
        ),
      ],
    );
  }
}
