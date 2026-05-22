import 'package:facility/facility.dart';
import 'package:flutter/material.dart';
import 'package:sport_manager_mobile/core/core.dart';
import 'package:sport_manager_mobile/features/home/home.dart';
import 'package:sport_manager_mobile/l10n/l10n.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

class SpotCardFooter extends StatelessWidget {
  const SpotCardFooter(this.spot, {super.key});

  final SpotModel spot;

  String _statusLabel(BuildContext context, SessionModel session) {
    final name = session.customerName;
    if (session.isPaused) {
      return name != null && name.isNotEmpty ? context.l10n.homeSpotPaused(name) : context.l10n.homeSpotPausedBase;
    }
    return name != null && name.isNotEmpty ? context.l10n.homeSpotOccupied(name) : context.l10n.homeSpotOccupiedBase;
  }

  @override
  Widget build(BuildContext context) {
    final rate =
        '${spot.tarifAmount} ${spot.currency.localizedName(context.l10n).toLowerCase()}'
        ' ${spot.tarifType.localizedUnit(context.l10n).toLowerCase()}';
    if (spot.isOccupied) {
      return ListTile(
        dense: true,
        contentPadding: EdgeInsets.zero,
        minTileHeight: 0,
        title: SessionTimer(spot.session!),
        subtitle: Text(
          _statusLabel(context, spot.session!),
          style: context.textTheme.labelMedium?.copyWith(
            color: context.colors.error,
            fontWeight: FontWeight.w600,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      );
    }

    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.zero,
      minTileHeight: 0,
      title: Text(
        context.l10n.homeSpotFree,
        style: context.textTheme.labelMedium?.copyWith(
          color: context.appColors.success,
          fontWeight: FontWeight.w700,
        ),
      ),
      subtitle: Text(
        rate,
        style: context.textTheme.bodySmall?.copyWith(
          color: context.colors.onSurfaceVariant,
        ),
      ),
    );
  }
}
