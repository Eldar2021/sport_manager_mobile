import 'package:flutter/material.dart';
import 'package:sessions/sessions.dart';
import 'package:sport_manager_mobile/l10n/l10n.dart';
import 'package:sport_manager_mobile/ui/ui.dart';
import 'package:tables/tables.dart';

class HomeTableCard extends StatefulWidget {
  const HomeTableCard({
    required this.table,
    required this.onTap,
    this.session,
    this.isJustFreed = false,
    super.key,
  });

  final TableModel table;
  final SessionModel? session;
  final bool isJustFreed;
  final VoidCallback onTap;

  @override
  State<HomeTableCard> createState() => _HomeTableCardState();
}

class _HomeTableCardState extends State<HomeTableCard> with SingleTickerProviderStateMixin {
  late final AnimationController _pulseCtrl;
  late final Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 900));
    _pulseAnim = Tween<double>(begin: 0.4, end: 1).animate(
      CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut),
    );
    if (widget.table.status == TableStatus.occupied) _pulseCtrl.repeat(reverse: true);
  }

  @override
  void didUpdateWidget(HomeTableCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    final isOccupied = widget.table.status == TableStatus.occupied;
    if (isOccupied && !_pulseCtrl.isAnimating) {
      _pulseCtrl
        ..stop()
        ..repeat(reverse: true);
    } else if (!isOccupied && _pulseCtrl.isAnimating) {
      _pulseCtrl
        ..stop()
        ..value = 1;
    }
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    super.dispose();
  }

  String _formatElapsed(Duration elapsed) {
    final h = elapsed.inHours;
    final m = elapsed.inMinutes.remainder(60);
    final s = elapsed.inSeconds.remainder(60);
    final hh = h.toString().padLeft(2, '0');
    final mm = m.toString().padLeft(2, '0');
    final ss = s.toString().padLeft(2, '0');
    return '$hh:$mm:$ss';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final table = widget.table;
    final isOccupied = table.status == TableStatus.occupied;
    final isJustFreed = widget.isJustFreed;

    final Color borderColor;
    final Color bgColor;
    if (isOccupied) {
      borderColor = context.colors.error;
      bgColor = context.colors.errorContainer;
    } else if (isJustFreed) {
      borderColor = context.appColors.success;
      bgColor = context.appColors.successContainer;
    } else {
      borderColor = context.colors.outline;
      bgColor = context.colors.surface;
    }

    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: AppRadius.cardBorderRadius,
          border: Border.all(color: borderColor, width: 1.5),
        ),
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Flexible(
                  child: Text(
                    table.name ?? table.number,
                    style: context.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: context.colors.onSurface,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 5),
                _StatusDot(isOccupied: isOccupied, isJustFreed: isJustFreed, animation: _pulseAnim),
              ],
            ),
            const SizedBox(height: AppSpacing.x1),
            Text(
              table.description ?? table.number,
              style: context.textTheme.bodySmall?.copyWith(color: context.colors.onSurfaceVariant),
              overflow: TextOverflow.ellipsis,
            ),
            const Spacer(),
            if (isOccupied && widget.session != null) ...[
              Text(
                _formatElapsed(DateTime.now().difference(widget.session!.startedAt)),
                style: context.textTheme.headlineLarge?.copyWith(
                  color: context.colors.error,
                  fontWeight: FontWeight.w800,
                  fontFeatures: const [FontFeature.tabularFigures()],
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                l10n.homeTableOccupied,
                style: context.textTheme.bodySmall?.copyWith(
                  color: context.colors.onSurfaceVariant,
                  letterSpacing: 0.5,
                ),
              ),
            ] else ...[
              Text(
                isJustFreed ? l10n.homeTableJustFreed : l10n.homeTableFree,
                style: context.textTheme.bodySmall?.copyWith(
                  color: context.appColors.success,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '${table.hourlyRate} сом/ час',
                style: context.textTheme.bodySmall?.copyWith(
                  color: context.colors.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _StatusDot extends StatelessWidget {
  const _StatusDot({
    required this.isOccupied,
    required this.isJustFreed,
    required this.animation,
  });

  final bool isOccupied;
  final bool isJustFreed;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    final color = isOccupied ? context.colors.error : context.appColors.success;

    if (isOccupied) {
      return AnimatedBuilder(
        animation: animation,
        builder: (context, _) => Opacity(
          opacity: animation.value,
          child: _dot(color),
        ),
      );
    }

    return _dot(color);
  }

  Widget _dot(Color color) => DecoratedBox(
    decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    child: const SizedBox.square(dimension: 9),
  );
}
