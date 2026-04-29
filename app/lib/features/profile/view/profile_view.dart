import 'package:auth/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:sport_manager_mobile/core/core.dart';
import 'package:sport_manager_mobile/features/profile/profile.dart';
import 'package:sport_manager_mobile/l10n/l10n.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

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

  Future<void> _refreshProfile() async {
    await _profileCubit.fetchProfile();
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
          padding: const EdgeInsets.all(AppSpacing.x4),
          children: [
            BlocBuilder<ProfileCubit, DataState<ProfileModel>>(
              bloc: _profileCubit,
              builder: (context, state) {
                if (state is DataSuccess<ProfileModel>) {
                  return UserProfileCard(state.data.user);
                }
                return const SizedBox.shrink();
              },
            ),
            BlocBuilder<ProfileCubit, DataState<ProfileModel>>(
              bloc: _profileCubit,
              builder: (context, state) {
                if (state is DataSuccess<ProfileModel> && state.data.user.role == UserRole.owner) {
                  return OwnerProfileExtraData(state.data);
                }
                return const SizedBox.shrink();
              },
            ),

            BlocBuilder<ProfileCubit, DataState<ProfileModel>>(
              bloc: _profileCubit,
              builder: (context, state) {
                if (state is DataSuccess<ProfileModel>) {
                  return UserProfileExtraData(state.data);
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class UserProfileExtraData extends StatelessWidget {
  const UserProfileExtraData(this.data, {super.key});

  final ProfileModel data;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: AppSpacing.x6),
        Text(
          'Аккаунт',
          style: context.appTextStyles.disabled.bodyMedium,
        ),
        const SizedBox(height: AppSpacing.x2),
        Card(
          margin: EdgeInsets.zero,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (data.subscriptionEndDate != null)
                ProfileItemTile(
                  title: 'Подписка',
                  subtitle: '${data.venuesCount} залов',
                  iconBgColor: context.colors.primary.withValues(alpha: 0.1),
                  icon: Icon(
                    Icons.location_on,
                    color: context.colors.primary,
                  ),
                  onTap: () {},
                ),
              if (data.subscriptionEndDate != null) const Divider(),
              ProfileItemTile(
                title: 'Менеджеры',
                subtitle: '${data.managersCount} менеджеров',
                iconBgColor: context.appColors.successContainer,
                icon: Icon(
                  Icons.group,
                  color: context.appColors.success,
                ),
                onTap: () {},
              ),
            ],
          ),
        ),
      ],
    );
  }
}
