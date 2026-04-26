import 'package:flutter/material.dart';

/// Single source of truth for every color used in the app.
///
/// To find where a Figma hex value lives, search this file. The doc comment
/// above each constant tells you how the color is exposed by the theme so
/// you can read it via `Theme.of(context)` or `AppColorsExt` instead of
/// importing the constant directly.
///
/// Access patterns:
/// - `colorScheme.X` → `context.colors.X`
/// - `appColorsExt.X` → `context.appColors.X`
/// - `AppShadow.X` → raw token; `context.appColors.shadowX` is theme-aware.
abstract final class AppColors {
  /// Brand primary.
  /// → `colorScheme.primary` (light + dark)
  static const Color brandAmber = Color(0xFFD97706);

  /// Brand dark variant.
  /// → `colorScheme.primaryContainer` (dark) / `colorScheme.onPrimaryContainer` (light)
  /// → `colorScheme.inversePrimary` (dark)
  static const Color brandAmberDark = Color(0xFFB45309);

  /// Brand light variant.
  /// → `colorScheme.primaryContainer` (light) / `colorScheme.onPrimaryContainer` (dark)
  /// → `colorScheme.inversePrimary` (light)
  static const Color brandAmberLight = Color(0xFFFEF3C7);

  /// Soft brand overlay (light) — used for the NavigationBar indicator.
  /// → `appColors.brandAmberSoft` (light)
  static const Color brandAmberSoftLight = Color(0x20D97706);

  /// Soft brand overlay (dark).
  /// → `appColors.brandAmberSoft` (dark)
  static const Color brandAmberSoftDark = Color(0x33D97706);

  /// Success / positive state color.
  /// → `colorScheme.secondary` (light + dark)
  /// → `appColors.success`
  static const Color successGreen = Color(0xFF65A30D);

  /// Success dark variant.
  /// → `colorScheme.secondaryContainer` (dark) / `colorScheme.onSecondaryContainer` (light)
  /// → `appColors.successContainer` (dark) / `appColors.onSuccessContainer` (light)
  static const Color successDark = Color(0xFF4D7C0F);

  /// Success light variant.
  /// → `colorScheme.secondaryContainer` (light) / `colorScheme.onSecondaryContainer` (dark)
  /// → `appColors.successContainer` (light) / `appColors.onSuccessContainer` (dark)
  static const Color successLight = Color(0xFFECFCCB);

  /// Danger / error color.
  /// → `colorScheme.error` (light + dark)
  static const Color dangerRed = Color(0xFFDC2626);

  /// Danger dark variant.
  /// → `colorScheme.errorContainer` (dark) / `colorScheme.onErrorContainer` (light)
  static const Color dangerDark = Color(0xFFB91C1C);

  /// Danger light variant.
  /// → `colorScheme.errorContainer` (light) / `colorScheme.onErrorContainer` (dark)
  static const Color dangerLight = Color(0xFFFEE2E2);

  /// Warning color.
  /// → `appColors.warning`
  static const Color warningAmber = Color(0xFFF59E0B);

  /// Warning light variant.
  /// → `appColors.warningContainer` (light)
  static const Color warningLight = Color(0xFFFEF3C7);

  /// Info color.
  /// → `colorScheme.tertiary` (light + dark)
  /// → `appColors.info`
  static const Color infoCyan = Color(0xFF0891B2);

  /// Info dark variant (cyan-800).
  /// → `colorScheme.tertiaryContainer` (dark)
  /// → `appColors.infoContainer` (dark)
  static const Color infoDark = Color(0xFF155E75);

  /// Info light variant.
  /// → `colorScheme.tertiaryContainer` (light)
  /// → `appColors.infoContainer` (light)
  static const Color infoLight = Color(0xFFCFFAFE);

  /// Darkest text / surface tone.
  /// → `colorScheme.onSurface` (light)
  /// → `colorScheme.inverseSurface` (light)
  /// → `appColors.onWarning`
  static const Color ink900 = Color(0xFF1C1917);

  /// Secondary text (light).
  /// → `colorScheme.outlineVariant` (dark)
  static const Color ink700 = Color(0xFF44403C);

  /// Helper text / disabled.
  /// → `colorScheme.onSurfaceVariant` (light)
  static const Color ink500 = Color(0xFF78716C);

  /// Border / disabled background (light).
  /// → `colorScheme.outline` (light)
  /// → `colorScheme.onSurfaceVariant` (dark)
  static const Color ink300 = Color(0xFFD6D3D1);

  /// Soft surface (light).
  /// → `colorScheme.surfaceContainerHigh / surfaceContainerHighest` (light)
  /// → `colorScheme.outlineVariant` (light)
  /// → `colorScheme.inverseSurface` (dark)
  static const Color ink100 = Color(0xFFF5F5F4);

  /// Lightest neutral (reserved; not currently used by ColorScheme).
  static const Color ink50 = Color(0xFFFAFAF9);

  /// White.
  /// → `colorScheme.onPrimary / onSecondary / onError / onTertiary`
  /// → `colorScheme.onInverseSurface` (light)
  /// → `colorScheme.surface / surfaceContainer / surfaceContainerLowest / surfaceContainerLow` (light)
  /// → `colorScheme.onSurface` (dark)
  static const Color white = Color(0xFFFFFFFF);

  /// Pure black — `colorScheme.shadow / scrim`.
  static const Color black = Color(0xFF000000);

  /// Transparent — surface tints, status bar, transparent overlays.
  static const Color transparent = Color(0x00000000);

  /// Modal / scrim overlay (50% black).
  static const Color overlay = Color(0x80000000);

  /// Dark mode scaffold background.
  /// → `colorScheme.surfaceContainerLow / surfaceContainerLowest` (dark)
  /// → Scaffold background (dark)
  static const Color darkBgPrimary = Color(0xFF0F0D0B);

  /// Dark mode card / sheet / dialog surface.
  /// → `colorScheme.surface / surfaceContainer / surfaceContainerHigh` (dark)
  static const Color darkBgSecondary = Color(0xFF161310);

  /// Dark mode chip / input / tonal-button surface.
  /// → `colorScheme.surfaceContainerHighest` (dark)
  static const Color darkBgTertiary = Color(0xFF201B17);

  /// Dark mode border / divider.
  /// → `colorScheme.outline` (dark)
  static const Color darkBgBorder = Color(0xFF2E2825);

  /// Light mode scaffold background (warm off-white).
  /// → `colorScheme.surfaceContainerLow` (light)
  /// → Scaffold background (light)
  static const Color bgWarm = Color(0xFFFAF6F0);

  /// Light shadow (light mode) — sm.
  /// → `AppShadow.smLight`
  static const Color shadowSmLight = Color(0x0A000000);

  /// Medium shadow (light mode) — md.
  /// → `AppShadow.mdLight`
  static const Color shadowMdLight = Color(0x14000000);

  /// Strong shadow (light mode) — lg.
  /// → `AppShadow.lgLight`
  static const Color shadowLgLight = Color(0x1F000000);

  /// Light shadow (dark mode) — denser black so it remains visible on dark surfaces.
  /// → `AppShadow.smDark`
  static const Color shadowSmDark = Color(0x33000000);

  /// Medium shadow (dark mode).
  /// → `AppShadow.mdDark`
  static const Color shadowMdDark = Color(0x47000000);

  /// Strong shadow (dark mode).
  /// → `AppShadow.lgDark`
  static const Color shadowLgDark = Color(0x66000000);
}
