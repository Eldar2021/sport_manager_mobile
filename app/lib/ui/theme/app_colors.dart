import 'package:flutter/material.dart';
import 'package:sport_manager_mobile/ui/theme/colors/brand_colors.dart';
import 'package:sport_manager_mobile/ui/theme/colors/neutral_colors.dart';
import 'package:sport_manager_mobile/ui/theme/colors/semantic_colors.dart';
import 'package:sport_manager_mobile/ui/theme/colors/surface_colors.dart';

abstract final class AppColors {
  static const Color brandAmber = BrandColors.amber;
  static const Color brandAmberDark = BrandColors.amberDark;
  static const Color brandAmberLight = BrandColors.amberLight;

  static const Color successGreen = SemanticColors.successGreen;
  static const Color successDark = SemanticColors.successDark;
  static const Color successLight = SemanticColors.successLight;

  static const Color dangerRed = SemanticColors.dangerRed;
  static const Color dangerDark = SemanticColors.dangerDark;
  static const Color dangerLight = SemanticColors.dangerLight;

  static const Color warningAmber = SemanticColors.warningAmber;
  static const Color infoCyan = SemanticColors.infoCyan;

  static const Color ink900 = NeutralColors.ink900;
  static const Color ink700 = NeutralColors.ink700;
  static const Color ink500 = NeutralColors.ink500;
  static const Color ink300 = NeutralColors.ink300;
  static const Color ink100 = NeutralColors.ink100;
  static const Color ink50 = NeutralColors.ink50;
  static const Color white = NeutralColors.white;

  static const Color darkBgPrimary = SurfaceColors.darkBgPrimary;
  static const Color darkBgSecondary = SurfaceColors.darkBgSecondary;
  static const Color darkBgTertiary = SurfaceColors.darkBgTertiary;
  static const Color darkBgBorder = SurfaceColors.darkBgBorder;

  static const Color bgWarm = SurfaceColors.bgWarm;
  static const Color card = SurfaceColors.card;

  static const Color transparent = NeutralColors.transparent;
  static const Color overlay = NeutralColors.overlay;
}
