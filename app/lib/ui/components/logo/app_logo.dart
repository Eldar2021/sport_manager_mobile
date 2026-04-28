import 'package:flutter/material.dart';
import 'package:sport_manager_mobile/generated/assets.gen.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({
    this.size = 88,
    super.key,
  });

  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: DecoratedBox(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: context.colors.primary.withValues(
                alpha: AppOpacity.brandGlow,
              ),
              blurRadius: AppSpacing.x6,
              offset: const Offset(0, AppSpacing.x3),
            ),
          ],
        ),
        child: Assets.icons.appIcon.svg(),
      ),
    );
  }
}
