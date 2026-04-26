import 'package:auth/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:sessions/sessions.dart';
import 'package:sport_manager_mobile/app/app.dart';
import 'package:sport_manager_mobile/features/auth/auth.dart';
import 'package:sport_manager_mobile/features/home/home.dart';
import 'package:sport_manager_mobile/ui/ui.dart';
import 'package:tables/tables.dart';
import 'package:venues/venues.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeCubit(
        GetIt.I<VenueRepository>(),
        GetIt.I<TableRepository>(),
        GetIt.I<SessionRepository>(),
      )..load(),
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();

  @override
  Widget build(BuildContext context) {
    final isOwner = context.select<AuthCubit, bool>(
      (c) => c.state is AuthAuthenticated && (c.state as AuthAuthenticated).role == UserRole.owner,
    );

    return BlocBuilder<HomeCubit, HomeState>(
      buildWhen: (prev, next) =>
          prev.isInitialLoading != next.isInitialLoading ||
          prev.venues.isEmpty != next.venues.isEmpty ||
          prev.selectedVenue != next.selectedVenue ||
          prev.tables.length != next.tables.length,
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            automaticallyImplyLeading: false,
            centerTitle: false,
            titleSpacing: 0,
            title: state.selectedVenue != null
                ? HomeVenueBar(
                    venue: state.selectedVenue!,
                    tableCount: state.tables.length,
                    onTap: () => HomeVenuePicker.show(
                      context,
                      venues: state.venues,
                      selectedVenue: state.selectedVenue,
                      isOwner: isOwner,
                      onSelect: context.read<HomeCubit>().selectVenue,
                    ),
                  )
                : null,
          ),
          floatingActionButton: isOwner && state.selectedVenue != null
              ? FloatingActionButton(
                  onPressed: () => context.push(AppRoutes.createTable, extra: state.selectedVenue!.id),
                  backgroundColor: AppColors.brandAmber,
                  foregroundColor: AppColors.white,
                  child: const Icon(Icons.add_rounded),
                )
              : null,
          body: SafeArea(
            bottom: false,
            child: _TablesBody(isOwner: isOwner),
          ),
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
        if (state.isInitialLoading) return const VenuesSkeletonWidget();

        if (state.venues.isEmpty) {
          return VenuesEmptyWidget(onCreateTap: () => context.push(AppRoutes.createVenue));
        }

        if (state.isTablesLoading) return const VenuesSkeletonWidget();

        if (state.tables.isEmpty) {
          return TablesEmptyWidget(
            onAddTap: isOwner ? () => context.push(AppRoutes.createTable, extra: state.selectedVenue!.id) : null,
          );
        }

        return RefreshIndicator(
          onRefresh: context.read<HomeCubit>().refresh,
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.x4,
                    AppSpacing.x4,
                    AppSpacing.x4,
                    AppSpacing.x3,
                  ),
                  child: Text(
                    'СТОЛЫ · ${state.tables.length}',
                    style: AppTypography.caption.copyWith(
                      color: AppColors.ink500,
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
                          session: state.activeSessions[table.id],
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
