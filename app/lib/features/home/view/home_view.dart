import 'package:core/core.dart';
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
import 'package:sport_manager_mobile/ui/ui.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeCubit(GetIt.I<FacilityRepository>())..load(),
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();

  @override
  Widget build(BuildContext context) {
    final isOwner = context.read<AuthCubit>().state.isOwner;

    return BlocBuilder<HomeCubit, HomeState>(
      buildWhen: (prev, next) =>
          prev.isLoading != next.isLoading ||
          prev.selectedVenue != next.selectedVenue ||
          prev.tables.length != next.tables.length,
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            centerTitle: false,
            titleSpacing: 0,
            title: state.selectedVenue != null
                ? HomeVenueBar(
                    venue: state.selectedVenue!,
                    tableCount: state.tables.length,
                    onTap: () => VenueSelectorSheet.show(
                      context,
                      selectedVenue: state.selectedVenue,
                      isOwner: isOwner,
                      onSelect: context.read<HomeCubit>().selectVenue,
                    ),
                  )
                : null,
          ),
          floatingActionButton: state.selectedVenue != null && isOwner
              ? FloatingActionButton(
                  onPressed: () => context.push(
                    AppRoutes.tableForm,
                    extra: TableFormExtra(venueId: state.selectedVenue!.id),
                  ),
                  child: const Icon(Icons.add_rounded),
                )
              : null,
          body: _TablesBody(isOwner: isOwner),
        );
      },
    );
  }
}

class _TablesBody extends StatelessWidget {
  const _TablesBody({required this.isOwner});

  final bool isOwner;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        if (state.isLoading) return const VenuesSkeletonWidget();

        final status = state.selectedStatus;
        if (status is RequestFailure<SelectedVenueModel>) {
          final err = status.exception;
          if (err is VenueException && err.error == VenueErrorCode.notFound) {
            return VenuesEmptyWidget(onCreateTap: () => context.push(AppRoutes.venueForm));
          }
          return ErrorBodyWidget(err, onRetryPressed: context.read<HomeCubit>().load);
        }

        if (state.tables.isEmpty) {
          return TablesEmptyWidget(
            onAddTap: isOwner
                ? () => context.push(
                    AppRoutes.tableForm,
                    extra: TableFormExtra(venueId: state.selectedVenue!.id),
                  )
                : null,
          );
        }

        return RefreshIndicator(
          onRefresh: context.read<HomeCubit>().refresh,
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(AppSpacing.x4, AppSpacing.x4, AppSpacing.x4, AppSpacing.x3),
                  child: Text(
                    'СТОЛЫ · ${state.tables.length}',
                    style: context.textTheme.bodySmall?.copyWith(
                      color: context.colors.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.x4,
                  0,
                  AppSpacing.x4,
                  AppSpacing.x16,
                ),
                sliver: SliverGrid.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: AppSpacing.x3,
                  crossAxisSpacing: AppSpacing.x3,
                  childAspectRatio: 0.95,
                  children: state.tables
                      .map(
                        (table) => HomeTableCard(
                          key: ValueKey(table.id),
                          table: table,
                          isJustFreed: state.justFreedTableIds.contains(table.id),
                          onTap: () {},
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
