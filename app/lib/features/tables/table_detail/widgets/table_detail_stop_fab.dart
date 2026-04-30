import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sport_manager_mobile/features/tables/tables.dart';
import 'package:sport_manager_mobile/l10n/l10n.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

class TableDetailStopFab extends StatelessWidget {
  const TableDetailStopFab({
    required this.sessionCubit,
    required this.onPressed,
    super.key,
  });

  final SessionActiveCubit sessionCubit;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x4),
      child: BlocBuilder<SessionActiveCubit, SessionActiveState>(
        bloc: sessionCubit,
        buildWhen: (prev, curr) => prev.stopStatus != curr.stopStatus,
        builder: (context, state) => FilledButton(
          onPressed: state.stopStatus.isLoading ? null : onPressed,
          style: FilledButton.styleFrom(
            backgroundColor: context.colors.error,
            foregroundColor: context.colors.onError,
            minimumSize: const Size(double.infinity, AppSpacing.x16),
            shape: const RoundedRectangleBorder(
              borderRadius: AppRadius.buttonBorderRadius,
            ),
          ),
          child: state.stopStatus.isLoading ? const AppActivityIndicator() : Text(context.l10n.tableDetailStop),
        ),
      ),
    );
  }
}
