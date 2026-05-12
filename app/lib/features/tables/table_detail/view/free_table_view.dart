import 'dart:async';
import 'package:core/core.dart';
import 'package:facility/facility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sport_manager_mobile/app/app.dart';
import 'package:sport_manager_mobile/core/core.dart';
import 'package:sport_manager_mobile/features/home/home.dart';
import 'package:sport_manager_mobile/features/tables/tables.dart';
import 'package:sport_manager_mobile/l10n/l10n.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

class FreeTableView extends StatefulWidget {
  const FreeTableView({
    required this.tableCubit,
    required this.table,
    super.key,
  });

  final TableDetailCubit tableCubit;
  final TableModel table;

  @override
  State<FreeTableView> createState() => _FreeTableViewState();
}

class _FreeTableViewState extends State<FreeTableView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(widget.table.name ?? context.l10n.homeTableTitle(widget.table.number)),
        actions: [
          AppEditDeleteMenu(
            onEdit: _onEdit,
            onDelete: _onDelete,
          ),
        ],
      ),
      body: BlocListener<TableDetailCubit, TableDetailState>(
        bloc: widget.tableCubit,
        listener: (context, state) {
          if (state is TableDetailFree && state.startStatus.isFailure) {
            final exception = (state.startStatus as RequestFailure<SessionModel>).exception;
            context.handleError(exception);
          }
          if (state is TableDetailOccupied) {
            unawaited(context.read<HomeCubit>().load());
          }
        },
        child: FreeTableBody(widget.table),
      ),
      floatingActionButtonLocation: kAppButtonFabLocation,
      floatingActionButton: BlocBuilder<TableDetailCubit, TableDetailState>(
        bloc: widget.tableCubit,
        buildWhen: (p, c) => p is TableDetailFree && c is TableDetailFree && p.startStatus != c.startStatus,
        builder: (context, state) {
          final isLoading = state is TableDetailFree && state.startStatus.isLoading;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x4),
            child: FilledButton(
              onPressed: isLoading ? null : widget.tableCubit.startSession,
              style: FilledButton.styleFrom(
                backgroundColor: context.appColors.success,
                foregroundColor: context.appColors.onSuccess,
                minimumSize: const Size(double.infinity, AppSpacing.x16),
                shape: const RoundedRectangleBorder(
                  borderRadius: AppRadius.buttonBorderRadius,
                ),
              ),
              child: isLoading ? const AppActivityIndicator() : Text(context.l10n.tableDetailStart),
            ),
          );
        },
      ),
    );
  }

  void _onEdit() {
    context.push(
      AppRoutes.tableForm,
      extra: TableFormExtra(
        venueId: widget.table.venueId,
        table: widget.table,
      ),
    );
  }

  Future<void> _onDelete() async {
    await AppDestructiveSheet.show(
      context,
      icon: Icons.delete_outline_rounded,
      title: context.l10n.deleteTableButton,
      subtitle: context.l10n.deleteTableSubtitle,
      confirmLabel: context.l10n.deleteTableButton,
      onConfirm: widget.tableCubit.deleteTable,
    );
    if (!mounted) return;
    final deleteStatus = switch (widget.tableCubit.state) {
      TableDetailFree(:final deleteStatus) => deleteStatus,
      TableDetailOccupied(:final deleteStatus) => deleteStatus,
    };
    if (deleteStatus.isSuccess) {
      unawaited(context.read<HomeCubit>().load());
      context.pop();
    } else if (deleteStatus is RequestFailure<bool>) {
      context.handleError(deleteStatus.exception);
    }
  }
}
