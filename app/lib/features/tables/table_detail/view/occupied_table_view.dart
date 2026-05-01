import 'package:core/core.dart';
import 'package:facility/facility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:sport_manager_mobile/core/core.dart';
import 'package:sport_manager_mobile/features/tables/tables.dart';
import 'package:sport_manager_mobile/l10n/l10n.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

class OccupiedTableView extends StatefulWidget {
  const OccupiedTableView({
    required this.tableCubit,
    required this.table,
    required this.session,
    super.key,
  });

  final TableDetailCubit tableCubit;
  final TableModel table;
  final SessionModel session;

  @override
  State<OccupiedTableView> createState() => _OccupiedTableViewState();
}

class _OccupiedTableViewState extends State<OccupiedTableView> {
  late final SessionActiveCubit _sessionCubit;

  @override
  void initState() {
    super.initState();
    _sessionCubit = SessionActiveCubit(
      session: widget.session,
      repository: GetIt.I<SessionRepository>(),
    );
  }

  @override
  void dispose() {
    _sessionCubit.close();
    super.dispose();
  }

  void _showPaymentSheet() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) => BlocProvider.value(
        value: _sessionCubit,
        child: PaymentSummarySheet(widget.table),
      ),
    );
  }

  void _showCancelConfirm() {
    AppDestructiveSheet.show(
      context,
      icon: Icons.cancel_outlined,
      title: context.l10n.tableDetailMistakeLaunchTitle,
      subtitle: context.l10n.tableDetailMistakeLaunchSubtitle,
      confirmLabel: context.l10n.tableDetailMistakeLaunchConfirm,
      onConfirm: _sessionCubit.cancelSession,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          widget.table.name ?? context.l10n.homeTableTitle(widget.table.number),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert_rounded),
            onPressed: () {},
          ),
        ],
      ),
      body: BlocProvider.value(
        value: _sessionCubit,
        child: BlocListener<SessionActiveCubit, SessionActiveState>(
          bloc: _sessionCubit,
          listenWhen: _listenWhen,
          listener: _listener,
          child: OccupiedTableBody(
            currency: widget.table.currency.localizedName(context.l10n),
            onMistakeLaunch: _showCancelConfirm,
          ),
        ),
      ),
      floatingActionButtonLocation: kAppButtonFabLocation,
      floatingActionButton: OccupiedTableFooter(
        sessionCubit: _sessionCubit,
        onStopPressed: _showPaymentSheet,
      ),
    );
  }

  bool _listenWhen(SessionActiveState p, SessionActiveState c) =>
      p.stopStatus != c.stopStatus ||
      p.cancelStatus != c.cancelStatus ||
      p.pauseStatus != c.pauseStatus ||
      p.resumeStatus != c.resumeStatus;

  void _listener(BuildContext context, SessionActiveState state) {
    if (state.stopStatus.isSuccess || state.cancelStatus.isSuccess) {
      widget.tableCubit.onSessionEnded();
    }
    if (state.cancelStatus.isFailure) {
      final exception = (state.cancelStatus as RequestFailure<SessionModel>).exception;
      context.handleError(exception);
    }
    if (state.pauseStatus.isFailure) {
      final exception = (state.pauseStatus as RequestFailure<SessionModel>).exception;
      context.handleError(exception);
    }
    if (state.resumeStatus.isFailure) {
      final exception = (state.resumeStatus as RequestFailure<SessionModel>).exception;
      context.handleError(exception);
    }
  }
}
