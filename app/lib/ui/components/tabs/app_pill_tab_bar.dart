import 'package:flutter/material.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

class AppPillTabBar extends StatelessWidget {
  const AppPillTabBar({
    required this.controller,
    required this.tabs,
    super.key,
  });

  final TabController controller;
  final List<Widget> tabs;

  @override
  Widget build(BuildContext context) {
    return TabBar(
      controller: controller,
      indicator: BoxDecoration(
        color: context.colors.primary,
        borderRadius: AppRadius.chipBorderRadius,
      ),
      indicatorSize: TabBarIndicatorSize.tab,
      indicatorPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x2,
        vertical: AppSpacing.x2,
      ),
      dividerColor: Colors.transparent,
      overlayColor: const WidgetStatePropertyAll(Colors.transparent),
      labelColor: context.colors.onPrimary,
      unselectedLabelColor: context.colors.onSurface,
      labelStyle: context.textTheme.labelLarge,
      unselectedLabelStyle: context.textTheme.labelLarge,
      tabs: tabs,
    );
  }
}
