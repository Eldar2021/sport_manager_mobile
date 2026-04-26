import 'package:flutter/material.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

class VenuesSkeletonWidget extends StatefulWidget {
  const VenuesSkeletonWidget({super.key});

  @override
  State<VenuesSkeletonWidget> createState() => _VenuesSkeletonWidgetState();
}

class _VenuesSkeletonWidgetState extends State<VenuesSkeletonWidget> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _opacity = Tween<double>(begin: 0.35, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: AnimatedBuilder(
        animation: _opacity,
        builder: (context, _) => GridView.count(
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: AppSpacing.x3,
          crossAxisSpacing: AppSpacing.x3,
          childAspectRatio: 1.05,
          children: List.generate(
            6,
            (_) => DecoratedBox(
              decoration: BoxDecoration(
                color: context.colors.outline.withValues(alpha: _opacity.value),
                borderRadius: AppRadius.cardBorderRadius,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
