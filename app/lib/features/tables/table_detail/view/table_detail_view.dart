import 'package:core/core.dart';
import 'package:facility/facility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:sport_manager_mobile/core/core.dart';
import 'package:sport_manager_mobile/features/tables/table_detail/widgets/table_detail_start_fab.dart';
import 'package:sport_manager_mobile/features/tables/tables.dart';
import 'package:sport_manager_mobile/l10n/l10n.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

class TableDetailView extends StatefulWidget {
  const TableDetailView(this.table, {super.key});

  final TableModel table;

  @override
  State<TableDetailView> createState() => _TableDetailViewState();
}

class _TableDetailViewState extends State<TableDetailView> {
  late final TableDetailCubit _tableCubit;

  @override
  void initState() {
    super.initState();
    _tableCubit = TableDetailCubit(
      table: widget.table,
      repository: GetIt.I<SessionRepository>(),
    );
  }

  @override
  void dispose() {
    _tableCubit.close();
    super.dispose();
  }

  void _showPaymentSheet(
    TableModel table,
    SessionActiveCubit sessionCubit,
  ) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) => BlocProvider.value(
        value: sessionCubit,
        child: PaymentSummarySheet(table),
      ),
    );
  }

  void _showCancelConfirm(SessionActiveCubit sessionCubit) {
    AppDestructiveSheet.show(
      context,
      icon: Icons.cancel_outlined,
      title: context.l10n.tableDetailMistakeLaunchTitle,
      subtitle: context.l10n.tableDetailMistakeLaunchSubtitle,
      confirmLabel: context.l10n.tableDetailMistakeLaunchConfirm,
      onConfirm: sessionCubit.cancelSession,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TableDetailCubit, TableDetailState>(
      bloc: _tableCubit,
      listener: (context, state) {
        if (state is TableDetailFree && state.startStatus.isFailure) {
          final exc = (state.startStatus as RequestFailure<SessionModel>).exception;
          context.handleError(exc);
        }
      },
      builder: (context, tableState) {
        final table = switch (tableState) {
          TableDetailFree(:final table) => table,
          TableDetailOccupied(:final table) => table,
        };

        return Scaffold(
          appBar: AppBar(
            centerTitle: false,
            title: Text(table.name ?? context.l10n.homeTableTitle(table.number)),
            actions: [
              IconButton(
                icon: const Icon(Icons.more_vert_rounded),
                onPressed: () {},
              ),
            ],
          ),
          body: switch (tableState) {
            TableDetailFree(:final table) => FreeTableBody(table),
            TableDetailOccupied(:final sessionCubit, :final table) => BlocProvider.value(
              value: sessionCubit,
              child: BlocListener<SessionActiveCubit, SessionActiveState>(
                listenWhen: (prev, curr) => prev.cancelStatus != curr.cancelStatus,
                listener: (context, state) {
                  if (state.cancelStatus.isFailure) {
                    final exc = (state.cancelStatus as RequestFailure<SessionModel>).exception;
                    context.handleError(exc);
                  }
                },
                child: ActiveSessionBody(
                  currency: table.currency.localizedName(context.l10n),
                  onMistakeLaunch: () => _showCancelConfirm(sessionCubit),
                ),
              ),
            ),
          },
          floatingActionButtonLocation: kAppButtonFabLocation,
          floatingActionButton: switch (tableState) {
            TableDetailFree(:final startStatus) => TableDetailStartFab(
              isLoading: startStatus.isLoading,
              onPressed: _tableCubit.startSession,
            ),
            TableDetailOccupied(:final sessionCubit, :final table) => TableDetailStopFab(
              sessionCubit: sessionCubit,
              onPressed: () => _showPaymentSheet(table, sessionCubit),
            ),
          },
        );
      },
    );
  }
}
