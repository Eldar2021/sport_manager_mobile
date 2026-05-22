import 'dart:async';
import 'package:core/core.dart';
import 'package:facility/facility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sport_manager_mobile/app/app.dart';
import 'package:sport_manager_mobile/core/core.dart';
import 'package:sport_manager_mobile/features/auth/auth.dart';
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
  late TableModel _table;

  @override
  void initState() {
    super.initState();
    _table = widget.table;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(_table.name ?? context.l10n.homeTableTitle(_table.number)),
        actions: [
          if (context.read<AuthCubit>().state.isOwner)
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
        child: FreeTableBody(_table),
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
              onPressed: isLoading ? null : _onStartSession,
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

  Future<void> _onStartSession() async {
    final customerName = await StartSessionSheet.show(context);
    if (customerName == null || !mounted) return;

    await widget.tableCubit.startSession(customerName.trim().isEmpty ? null : customerName.trim());
  }

  Future<void> _onEdit() async {
    final updated = await context.push<TableModel>(
      AppRoutes.tableForm,
      extra: TableFormExtra(
        venueId: _table.venueId,
        table: _table,
      ),
    );
    if (!mounted || updated == null) return;
    setState(() => _table = updated);
    widget.tableCubit.updateTable(updated);
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
      await WidgetsBinding.instance.endOfFrame;
      if (!mounted) return;
      context.pop();
    } else if (deleteStatus is RequestFailure<bool>) {
      context.handleError(deleteStatus.exception);
    }
  }
}
