import 'dart:async';
import 'package:auth/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:managers/managers.dart';
import 'package:sport_manager_mobile/core/core.dart';
import 'package:sport_manager_mobile/features/managers/managers.dart';
import 'package:sport_manager_mobile/features/profile/profile.dart';
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
          if (mounted) unawaited(context.read<ProfileCubit>().fetchProfile());
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
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.x4,
              AppSpacing.x4,
              AppSpacing.x4,
              kAppButtonFabClearance,
            ),
            children: [
              InviteCodeSection(_cubit),
              const SizedBox(height: AppSpacing.x6),
              Text(
                context.l10n.managersSectionLabel,
                style: context.appTextStyles.muted.labelSmall,
              ),
              const SizedBox(height: AppSpacing.x2),
              ManagersSection(
                cubit: _cubit,
                onDelete: _onDeleteManager,
              ),
            ],
          ),
        ),
        floatingActionButtonLocation: kAppButtonFabLocation,
        floatingActionButton: InviteActionButton(
          cubit: _cubit,
          onPressed: _onShareInvite,
        ),
      ),
    );
  }
}
