import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sport_manager_mobile/generated/assets.gen.dart';
import 'package:sport_manager_mobile/l10n/l10n.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

final class MainShell extends StatelessWidget {
  const MainShell({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  void _onTabTap(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final currentIndex = navigationShell.currentIndex;
    final surfaceColor = Theme.of(context).colorScheme.surface;

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: DecoratedBox(
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(AppRadius.modal),
            topRight: Radius.circular(AppRadius.modal),
          ),
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: AppSpacing.x2,
            ),
            child: Row(
              children: [
                _NavItem(
                  iconBuilder: (color) => Assets.icons.home.svg(
                    width: 24,
                    colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
                  ),
                  label: l10n.navHome,
                  isSelected: currentIndex == 0,
                  onTap: () => _onTabTap(0),
                ),
                _NavItem(
                  iconBuilder: (color) => Assets.icons.analytics.svg(
                    width: 24,
                    colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
                  ),
                  label: l10n.navReport,
                  isSelected: currentIndex == 1,
                  onTap: () => _onTabTap(1),
                ),
                _NavItem(
                  iconBuilder: (color) => Assets.icons.profile.svg(
                    width: 24,
                    colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
                  ),
                  label: l10n.navProfile,
                  isSelected: currentIndex == 2,
                  onTap: () => _onTabTap(2),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

final class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.iconBuilder,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final Widget Function(Color color) iconBuilder;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = isSelected ? AppColors.brandAmber : AppColors.ink500;

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            iconBuilder(color),
            const SizedBox(height: AppSpacing.x1),
            Text(
              label,
              style: AppTypography.caption.copyWith(
                color: color,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
            const SizedBox(height: AppSpacing.x1),
            AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              opacity: isSelected ? 1.0 : 0.0,
              child: const SizedBox.square(
                dimension: 4,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: AppColors.brandAmber,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
