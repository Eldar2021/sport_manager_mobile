import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sport_manager_mobile/features/auth/auth.dart';
import 'package:sport_manager_mobile/generated/assets.gen.dart';
import 'package:sport_manager_mobile/l10n/l10n.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

class MainView extends StatelessWidget {
  const MainView(this.navigationShell, {super.key});

  final StatefulNavigationShell navigationShell;

  void _onTabTap(int displayedIndex, bool isManager) {
    final branchIndex = isManager && displayedIndex == 1 ? 2 : displayedIndex;
    navigationShell.goBranch(
      branchIndex,
      initialLocation: branchIndex == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final primary = context.colors.primary;
    final muted = context.colors.onSurfaceVariant;

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: BlocSelector<AuthCubit, AuthState, bool>(
        selector: (state) => state.isManager,
        builder: (context, isManager) {
          final branchIndex = navigationShell.currentIndex;
          final displayedIndex = isManager && branchIndex == 2 ? 1 : branchIndex;

          return NavigationBar(
            selectedIndex: displayedIndex,
            onDestinationSelected: (i) => _onTabTap(i, isManager),
            destinations: [
              NavigationDestination(
                icon: Assets.icons.home.svg(
                  width: 24,
                  colorFilter: ColorFilter.mode(muted, BlendMode.srcIn),
                ),
                selectedIcon: Assets.icons.home.svg(
                  width: 24,
                  colorFilter: ColorFilter.mode(primary, BlendMode.srcIn),
                ),
                label: l10n.navHome,
              ),
              if (!isManager)
                NavigationDestination(
                  icon: Assets.icons.analytics.svg(
                    width: 24,
                    colorFilter: ColorFilter.mode(muted, BlendMode.srcIn),
                  ),
                  selectedIcon: Assets.icons.analytics.svg(
                    width: 24,
                    colorFilter: ColorFilter.mode(primary, BlendMode.srcIn),
                  ),
                  label: l10n.navReport,
                ),
              NavigationDestination(
                icon: Assets.icons.profile.svg(
                  width: 24,
                  colorFilter: ColorFilter.mode(muted, BlendMode.srcIn),
                ),
                selectedIcon: Assets.icons.profile.svg(
                  width: 24,
                  colorFilter: ColorFilter.mode(primary, BlendMode.srcIn),
                ),
                label: l10n.navProfile,
              ),
            ],
          );
        },
      ),
    );
  }
}
