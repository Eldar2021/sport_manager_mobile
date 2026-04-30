import 'package:auth/auth.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sport_manager_mobile/features/managers/managers.dart';

class InviteCodeSection extends StatelessWidget {
  const InviteCodeSection(this.cubit, {super.key});

  final ManagersCubit cubit;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ManagersCubit, ManagersState>(
      bloc: cubit,
      buildWhen: (a, b) => a.inviteCode != b.inviteCode,
      builder: (_, state) {
        return switch (state.inviteCode) {
          RequestInitial<InviteCodeModel>() || RequestLoading<InviteCodeModel>() => const InviteCodeCardSkeleton(),
          RequestFailure<InviteCodeModel>() => InviteCodeCard.error(onRetry: cubit.loadInviteCode),
          RequestSuccess<InviteCodeModel>(:final data) => InviteCodeCard.success(data),
        };
      },
    );
  }
}
