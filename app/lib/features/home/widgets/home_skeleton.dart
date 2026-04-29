import 'package:flutter/material.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

class HomeSkeleton extends StatefulWidget {
  const HomeSkeleton({super.key});

  @override
  State<HomeSkeleton> createState() => _HomeSkeletonState();
}

class _HomeSkeletonState extends State<HomeSkeleton> with SingleTickerProviderStateMixin {
  final List<_SkeletonCell> _items = List.generate(6, (_) => const _SkeletonCell());

  late final AnimationController _controller;
  late final Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _opacity = Tween<double>(begin: 0.3, end: 0.8).animate(
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
        builder: (context, _) => Opacity(
          opacity: _opacity.value,
          child: GridView.count(
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: AppSpacing.x3,
            crossAxisSpacing: AppSpacing.x3,
            childAspectRatio: 1.4,
            children: _items,
          ),
        ),
      ),
    );
  }
}

class _SkeletonCell extends StatelessWidget {
  const _SkeletonCell();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.colors.outline,
        borderRadius: AppRadius.cardBorderRadius,
      ),
      child: const SizedBox.expand(),
    );
  }
}
