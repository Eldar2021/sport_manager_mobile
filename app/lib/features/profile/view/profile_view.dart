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
              builder: (context, state) {
                if (state is DataSuccess<ProfileModel>) {
                  return UserProfileCard(state.data.user);
                }
                return const SizedBox.shrink();
              },
            ),

            const SizedBox(height: AppSpacing.x4),
            Text(
              'Управление',
              style: context.appTextStyles.disabled.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
