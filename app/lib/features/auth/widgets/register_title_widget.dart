import 'package:flutter/material.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

class RegisterTitleWidget extends StatelessWidget {
  const RegisterTitleWidget({
    required this.title,
    required this.badge,
    required this.icon,
    required this.variant,
    super.key,
  });

  final String title;
  final String badge;
  final IconData icon;
  final AppBadgeVariant variant;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x6, vertical: AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: AppSpacing.x3),
          AppBadge(label: badge, icon: icon, variant: variant),
        ],
      ),
    );
  }
}
