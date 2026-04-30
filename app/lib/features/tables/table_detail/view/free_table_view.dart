import 'package:core/core.dart';
import 'package:facility/facility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sport_manager_mobile/core/core.dart';
import 'package:sport_manager_mobile/features/tables/tables.dart';
import 'package:sport_manager_mobile/l10n/l10n.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

class FreeTableView extends StatelessWidget {
  const FreeTableView({
    required this.tableCubit,
    required this.table,
    super.key,
  });

  final TableDetailCubit tableCubit;
  final TableModel table;

  @override
  Widget build(BuildContext context) {
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
      body: BlocListener<TableDetailCubit, TableDetailState>(
        bloc: tableCubit,
        listener: (context, state) {
          if (state is TableDetailFree && state.startStatus.isFailure) {
            final exception = (state.startStatus as RequestFailure<SessionModel>).exception;
            context.handleError(exception);
          }
        },
        child: FreeTableBody(table),
      ),
      floatingActionButtonLocation: kAppButtonFabLocation,
      floatingActionButton: BlocBuilder<TableDetailCubit, TableDetailState>(
        bloc: tableCubit,
        buildWhen: (p, c) => p is TableDetailFree && c is TableDetailFree && p.startStatus != c.startStatus,
        builder: (context, state) {
          final isLoading = state is TableDetailFree && state.startStatus.isLoading;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x4),
            child: FilledButton(
              onPressed: isLoading ? null : tableCubit.startSession,
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
}
