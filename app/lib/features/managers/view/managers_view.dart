import 'package:auth/auth.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:managers/managers.dart';
import 'package:sport_manager_mobile/core/core.dart';
import 'package:sport_manager_mobile/features/managers/managers.dart';
import 'package:sport_manager_mobile/l10n/l10n.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

class ManagersView extends StatefulWidget {
  const ManagersView({super.key});

  @override
  State<ManagersView> createState() => _ManagersViewState();
}

class _ManagersViewState extends State<ManagersView> {
  late final ManagersCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = ManagersCubit(
      authRepository: GetIt.I<AuthRepository>(),
      managerRepository: GetIt.I<ManagerRepository>(),
    );
    _cubit.load();
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  Future<void> _onShareInvite() async {
    final code = _cubit.state.inviteCode.dataOrNull;
    if (code == null) {
      await _cubit.loadInviteCode();
      return;
    }
    await Clipboard.setData(ClipboardData(text: code.code));
    if (!mounted) return;
    context.showSuccessSnackBar(context.l10n.managersInviteCodeCopied);
  }

  Future<void> _onDeleteManager(ManagerModel manager) {
    return AppDestructiveSheet.show(
      context,
      icon: Icons.person_remove_outlined,
      title: context.l10n.managersDeleteTitle(manager.name),
      subtitle: context.l10n.managersDeleteSubtitle,
      confirmLabel: context.l10n.menuDelete,
      onConfirm: () async {
        try {
          await _cubit.deleteManager(manager.id);
        } on Object catch (e) {
          if (mounted) context.handleError(e);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppButtonScope(
      child: Scaffold(
        appBar: AppBar(title: Text(context.l10n.profileManagersTitle)),
        body: RefreshIndicator.adaptive(
          onRefresh: _cubit.load,
          child: BlocBuilder<ManagersCubit, ManagersState>(
            bloc: _cubit,
            builder: (context, state) {
              return ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.x4,
                  AppSpacing.x4,
                  AppSpacing.x4,
                  kAppButtonFabClearance,
                ),
                children: [
                  _InviteCodeSection(
                    status: state.inviteCode,
                    onRetry: _cubit.loadInviteCode,
                  ),
                  const SizedBox(height: AppSpacing.x6),
                  Text(
                    context.l10n.managersSectionLabel,
                    style: context.appTextStyles.muted.bodySmall.copyWith(
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.x2),
                  _ManagersSection(
                    status: state.managers,
                    deletingId: state.deletingId,
                    onDelete: _onDeleteManager,
                    onRetry: _cubit.loadManagers,
                  ),
                ],
              );
            },
          ),
        ),
        floatingActionButtonLocation: kAppButtonFabLocation,
        floatingActionButton: BlocBuilder<ManagersCubit, ManagersState>(
          bloc: _cubit,
          buildWhen: (a, b) => a.inviteCode != b.inviteCode,
          builder: (context, state) {
            final hasCode = state.inviteCode.isSuccess;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x4),
              child: AppButton(
                leading: const Icon(Icons.add_rounded),
                onPressed: hasCode ? _onShareInvite : null,
                child: Text(context.l10n.managersInviteAction),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _InviteCodeSection extends StatelessWidget {
  const _InviteCodeSection({required this.status, required this.onRetry});

  final RequestStatus<InviteCodeModel> status;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    return switch (status) {
      RequestInitial<InviteCodeModel>() || RequestLoading<InviteCodeModel>() => const InviteCodeCardSkeleton(),
      RequestFailure<InviteCodeModel>(:final exception) => ErrorBodyWidget(
        exception,
        onRetryPressed: onRetry,
      ),
      RequestSuccess<InviteCodeModel>(:final data) => InviteCodeCard(data),
    };
  }
}

class _ManagersSection extends StatelessWidget {
  const _ManagersSection({
    required this.status,
    required this.deletingId,
    required this.onDelete,
    required this.onRetry,
  });

  final RequestStatus<List<ManagerModel>> status;
  final String? deletingId;
  final ValueChanged<ManagerModel> onDelete;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    return switch (status) {
      RequestInitial<List<ManagerModel>>() || RequestLoading<List<ManagerModel>>() => const Card(
        margin: EdgeInsets.zero,
        child: ManagersListSkeleton(),
      ),
      RequestFailure<List<ManagerModel>>(:final exception) => ErrorBodyWidget(
        exception,
        onRetryPressed: onRetry,
      ),
      RequestSuccess<List<ManagerModel>>(:final data) when data.isEmpty => const Card(
        margin: EdgeInsets.zero,
        child: ManagersEmpty(),
      ),
      RequestSuccess<List<ManagerModel>>(:final data) => Card(
        margin: EdgeInsets.zero,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var i = 0; i < data.length; i++) ...[
              if (i != 0) const Divider(height: 1),
              ManagerCard(
                key: ValueKey(data[i].id),
                manager: data[i],
                isDeleting: deletingId == data[i].id,
                onDelete: () => onDelete(data[i]),
              ),
            ],
          ],
        ),
      ),
    };
  }
}
