import 'package:flutter/material.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

/// Lightweight loading placeholder shown until the period payload arrives.
/// Two grey blocks roughly matching the orange summary card + list area.
class ManagerReportSkeleton extends StatelessWidget {
  const ManagerReportSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final block = context.colors.surfaceContainerHighest;
    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.x4,
        AppSpacing.x4,
        AppSpacing.x4,
        AppSpacing.x8,
      ),
      children: [
        const SizedBox(height: AppSpacing.x4),
        _Block(color: block, height: 16, width: 140),
        const SizedBox(height: AppSpacing.x2),
        _Block(color: block, height: 28, width: 200),
        const SizedBox(height: AppSpacing.x4),
        _Block(color: block, height: 160),
        const SizedBox(height: AppSpacing.x4),
        for (var i = 0; i < 5; i++) ...[
          _Block(color: block, height: 72),
          const SizedBox(height: AppSpacing.x2),
        ],
      ],
    );
  }
}

class _Block extends StatelessWidget {
  const _Block({
    required this.color,
    required this.height,
    this.width,
  });

  final Color color;
  final double height;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: color,
          borderRadius: AppRadius.cardBorderRadius,
        ),
      ),
    );
  }
}
