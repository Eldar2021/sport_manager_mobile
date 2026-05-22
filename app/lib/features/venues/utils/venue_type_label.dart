import 'package:facility/facility.dart';
import 'package:flutter/material.dart';
import 'package:sport_manager_mobile/l10n/l10n.dart';

/// Maps [VenueType] to UI labels, plurals, and icons.
/// Backend always returns generic "spot" terminology; mobile composes the
/// type-aware label here.
extension VenueTypeX on VenueType {
  String spotLabel(BuildContext c) => switch (this) {
    VenueType.tableTennis || VenueType.billiards => c.l10n.spotLabelTable,
    VenueType.playStation => c.l10n.spotLabelConsole,
    VenueType.volleyball || VenueType.basketball => c.l10n.spotLabelCourt,
    VenueType.chess => c.l10n.spotLabelBoard,
    VenueType.football => c.l10n.spotLabelPitch,
  };

  String spotLabelPlural(BuildContext c) => switch (this) {
    VenueType.tableTennis || VenueType.billiards => c.l10n.spotLabelTablePlural,
    VenueType.playStation => c.l10n.spotLabelConsolePlural,
    VenueType.volleyball || VenueType.basketball => c.l10n.spotLabelCourtPlural,
    VenueType.chess => c.l10n.spotLabelBoardPlural,
    VenueType.football => c.l10n.spotLabelPitchPlural,
  };

  String typeName(BuildContext c) => switch (this) {
    VenueType.tableTennis => c.l10n.venueTypeTableTennis,
    VenueType.billiards => c.l10n.venueTypeBilliards,
    VenueType.playStation => c.l10n.venueTypePlayStation,
    VenueType.volleyball => c.l10n.venueTypeVolleyball,
    VenueType.basketball => c.l10n.venueTypeBasketball,
    VenueType.chess => c.l10n.venueTypeChess,
    VenueType.football => c.l10n.venueTypeFootball,
  };

  IconData get icon => switch (this) {
    VenueType.tableTennis => Icons.sports_tennis,
    VenueType.billiards => Icons.sports_bar,
    VenueType.playStation => Icons.sports_esports,
    VenueType.volleyball => Icons.sports_volleyball,
    VenueType.basketball => Icons.sports_basketball,
    VenueType.chess => Icons.grid_4x4,
    VenueType.football => Icons.sports_soccer,
  };
}
