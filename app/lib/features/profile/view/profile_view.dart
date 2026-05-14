import 'package:auth/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:sport_manager_mobile/core/core.dart';
import 'package:sport_manager_mobile/env.dart';
import 'package:sport_manager_mobile/features/auth/auth.dart';
import 'package:sport_manager_mobile/features/profile/profile.dart';
import 'package:sport_manager_mobile/l10n/l10n.dart';
import 'package:sport_manager_mobile/ui/ui.dart';
import 'package:talker_flutter/talker_flutter.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  late final ProfileCubit _profileCubit;

  @override
  void initState() {
    super.initState();
    _profileCubit = ProfileCubit(GetIt.I<AuthRepository>());
    _profileCubit.fetchProfile();
  }

  @override
  void dispose() {
    _profileCubit.close();
    super.dispose();
  }

  Future<void> _refreshProfile() => _profileCubit.fetchProfile();

  void _openTalker(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => TalkerScreen(talker: talker)),
    );
  }

  Future<void> _onLogout() {
    return AppDestructiveSheet.show(
      context,
      icon: Icons.logout_rounded,
      title: context.l10n.profileLogoutTitle,
      subtitle: context.l10n.profileLogoutSubtitle,
      confirmLabel: context.l10n.profileLogout,
      onConfirm: () => context.read<AuthCubit>().logout(),
    );
  }

  Future<void> _onDeleteAccount() async {
    final authCubit = context.read<AuthCubit>();
    Object? failure;
    await AppDestructiveSheet.show(
      context,
      icon: Icons.delete_outline_rounded,
      title: context.l10n.profileDeleteAccountTitle,
      subtitle: context.l10n.profileDeleteAccountSubtitle,
      confirmLabel: context.l10n.profileDeleteAccountConfirm,
      onConfirm: () async {
        try {
          await authCubit.deleteAccount();
        } on Object catch (e) {
          failure = e;
        }
      },
    );
    final error = failure;
    if (!mounted || error == null) return;
    context.handleError(error);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.navProfile),
      ),
      body: RefreshIndicator.adaptive(
        onRefresh: _refreshProfile,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(AppSpacing.x4),
          children: [
            BlocBuilder<ProfileCubit, DataState<ProfileModel>>(
              bloc: _profileCubit,
              builder: (context, state) {
                return switch (state) {
                  DataLoading<ProfileModel>() || DataInitial<ProfileModel>() => const _ProfileLoading(),
                  DataFailure<ProfileModel>() => ProfileErrorView(
                    error: state.exception,
                    onRetry: _refreshProfile,
                  ),
                  DataSuccess<ProfileModel>(:final data) => _ProfileLoaded(data),
                };
              },
            ),
            const SizedBox(height: AppSpacing.x6),
            FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: context.colors.surfaceContainer,
                foregroundColor: context.colors.error,
              ),
              onPressed: _onLogout,
              icon: const Icon(Icons.logout),
              label: Text(context.l10n.profileLogout),
            ),
            const SizedBox(height: AppSpacing.x3),
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                backgroundColor: AppColors.transparent,
                foregroundColor: context.colors.error,
                side: BorderSide(color: context.colors.error),
              ),
              onPressed: _onDeleteAccount,
              icon: const Icon(Icons.delete),
              label: Text(context.l10n.profileDeleteAccount),
            ),
            const SizedBox(height: AppSpacing.x6),
            Align(
              child: GestureDetector(
                onLongPress: Env.isDev ? () => _openTalker(context) : null,
                child: Text(
                  'Dula MVP',
                  style: context.appTextStyles.disabled.bodySmall,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileLoading extends StatelessWidget {
  const _ProfileLoading();

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        UserProfileCardSkeleton(),
        OwnerProfileExtraDataSkeleton(),
        UserProfileExtraDataSkeleton(),
      ],
    );
  }
}

class _ProfileLoaded extends StatelessWidget {
  const _ProfileLoaded(this.data);

  final ProfileModel data;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        UserProfileCard(data.user),
        if (data.user.role == UserRole.owner) OwnerProfileExtraData(data),
        UserProfileExtraData(data),
      ],
    );
  }
}
