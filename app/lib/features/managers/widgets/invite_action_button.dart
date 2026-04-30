import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sport_manager_mobile/features/managers/managers.dart';
import 'package:sport_manager_mobile/l10n/l10n.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

class InviteActionButton extends StatelessWidget {
  const InviteActionButton({
    required this.cubit,
    required this.onPressed,
    super.key,
  });

  final ManagersCubit cubit;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x4),
      child: BlocBuilder<ManagersCubit, ManagersState>(
        bloc: cubit,
        buildWhen: (a, b) => a.inviteCode.isSuccess != b.inviteCode.isSuccess,
        builder: (_, state) => AppButton(
          leading: const Icon(Icons.add_rounded),
          onPressed: state.inviteCode.isSuccess ? onPressed : null,
          child: Text(context.l10n.managersInviteAction),
        ),
      ),
    );
  }
}
