import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sport_manager_mobile/features/tables/tables.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

class ElapsedTimer extends StatelessWidget {
  const ElapsedTimer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SessionActiveCubit, SessionActiveState>(
      buildWhen: (p, c) => p.elapsed != c.elapsed || p.session.status != c.session.status,
      builder: (context, state) {
        final elapsed = state.elapsed;
        final isPaused = state.session.isPaused;
        final h = elapsed.inHours.toString().padLeft(2, '0');
        final m = (elapsed.inMinutes % 60).toString().padLeft(2, '0');
        final s = (elapsed.inSeconds % 60).toString().padLeft(2, '0');
        return Text(
          '$h:$m:$s',
          style: context.textTheme.displayLarge?.copyWith(
            fontWeight: FontWeight.w900,
            letterSpacing: -2,
            color: isPaused ? context.colors.primary : context.colors.onSurface,
          ),
          textAlign: TextAlign.center,
        );
      },
    );
  }
}
