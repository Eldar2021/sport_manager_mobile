import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Every text style the app ships with, all built from a single color via
/// `AppTextTheme.from(color)`. The same shape is reused inside `AppTextThemeExt`
/// to produce error / disabled / muted variants without duplicating the specs.
@immutable
final class AppTextTheme {
  const AppTextTheme({
    required this.displayLarge,
    required this.displayMedium,
    required this.displaySmall,
    required this.headlineLarge,
    required this.headlineMedium,
    required this.headlineSmall,
    required this.titleLarge,
    required this.titleMedium,
    required this.titleSmall,
    required this.bodyLarge,
    required this.bodyMedium,
    required this.bodySmall,
    required this.labelLarge,
    required this.labelMedium,
    required this.labelSmall,
    required this.amountSmall,
  });

  factory AppTextTheme.from(Color color) {
    return AppTextTheme(
      displayLarge: _style(56, 64, FontWeight.w700, tabular: true, color: color),
      displayMedium: _style(56, 64, FontWeight.w700, tabular: true, color: color),
      displaySmall: _style(32, 40, FontWeight.w700, tabular: true, color: color),
      headlineLarge: _style(28, 34, FontWeight.w700, color: color),
      headlineMedium: _style(22, 28, FontWeight.w600, color: color),
      headlineSmall: _style(18, 24, FontWeight.w600, color: color),
      titleLarge: _style(22, 28, FontWeight.w600, color: color),
      titleMedium: _style(18, 24, FontWeight.w600, color: color),
      titleSmall: _style(16, 24, FontWeight.w600, color: color),
      bodyLarge: _style(16, 24, FontWeight.w600, color: color),
      bodyMedium: _style(16, 24, FontWeight.w400, color: color),
      bodySmall: _style(13, 18, FontWeight.w500, color: color),
      labelLarge: _style(17, 22, FontWeight.w600, color: color),
      labelMedium: _style(13, 18, FontWeight.w500, color: color),
      labelSmall: _style(13, 18, FontWeight.w500, color: color),
      amountSmall: _style(24, 32, FontWeight.w700, tabular: true, color: color),
    );
  }

  factory AppTextTheme.lerp(AppTextTheme a, AppTextTheme b, double t) {
    return AppTextTheme(
      displayLarge: TextStyle.lerp(a.displayLarge, b.displayLarge, t)!,
      displayMedium: TextStyle.lerp(a.displayMedium, b.displayMedium, t)!,
      displaySmall: TextStyle.lerp(a.displaySmall, b.displaySmall, t)!,
      headlineLarge: TextStyle.lerp(a.headlineLarge, b.headlineLarge, t)!,
      headlineMedium: TextStyle.lerp(a.headlineMedium, b.headlineMedium, t)!,
      headlineSmall: TextStyle.lerp(a.headlineSmall, b.headlineSmall, t)!,
      titleLarge: TextStyle.lerp(a.titleLarge, b.titleLarge, t)!,
      titleMedium: TextStyle.lerp(a.titleMedium, b.titleMedium, t)!,
      titleSmall: TextStyle.lerp(a.titleSmall, b.titleSmall, t)!,
      bodyLarge: TextStyle.lerp(a.bodyLarge, b.bodyLarge, t)!,
      bodyMedium: TextStyle.lerp(a.bodyMedium, b.bodyMedium, t)!,
      bodySmall: TextStyle.lerp(a.bodySmall, b.bodySmall, t)!,
      labelLarge: TextStyle.lerp(a.labelLarge, b.labelLarge, t)!,
      labelMedium: TextStyle.lerp(a.labelMedium, b.labelMedium, t)!,
      labelSmall: TextStyle.lerp(a.labelSmall, b.labelSmall, t)!,
      amountSmall: TextStyle.lerp(a.amountSmall, b.amountSmall, t)!,
    );
  }

  /// 56 / 64 · w700 · tabular-nums — biggest number / timer display.
  final TextStyle displayLarge;

  /// 56 / 64 · w700 · tabular-nums — alias of [displayLarge].
  final TextStyle displayMedium;

  /// 32 / 40 · w700 · tabular-nums — large amount (money, stat).
  final TextStyle displaySmall;

  /// 28 / 34 · w700 — screen title (H1).
  final TextStyle headlineLarge;

  /// 22 / 28 · w600 — section title (H2).
  final TextStyle headlineMedium;

  /// 18 / 24 · w600 — subsection title (H3).
  final TextStyle headlineSmall;

  /// 22 / 28 · w600 — AppBar title (Material titleLarge slot).
  final TextStyle titleLarge;

  /// 18 / 24 · w600 — list-tile / row title.
  final TextStyle titleMedium;

  /// 16 / 24 · w600 — emphasized label.
  final TextStyle titleSmall;

  /// 16 / 24 · w600 — bold body text.
  final TextStyle bodyLarge;

  /// 16 / 24 · w400 — default body text.
  final TextStyle bodyMedium;

  /// 13 / 18 · w500 — caption / helper text.
  final TextStyle bodySmall;

  /// 17 / 22 · w600 — button label (Filled / Elevated / Outlined / Text).
  final TextStyle labelLarge;

  /// 13 / 18 · w500 — secondary label (chip, badge).
  final TextStyle labelMedium;

  /// 13 / 18 · w500 — small label (overline-style).
  final TextStyle labelSmall;

  /// 24 / 32 · w700 · tabular-nums — inline money amount (no Material slot).
  final TextStyle amountSmall;

  /// Convert to Material 3 [TextTheme] — pass to `ThemeData(textTheme: ...)`.
  TextTheme toMaterialTextTheme() {
    return TextTheme(
      displayLarge: displayLarge,
      displayMedium: displayMedium,
      displaySmall: displaySmall,
      headlineLarge: headlineLarge,
      headlineMedium: headlineMedium,
      headlineSmall: headlineSmall,
      titleLarge: titleLarge,
      titleMedium: titleMedium,
      titleSmall: titleSmall,
      bodyLarge: bodyLarge,
      bodyMedium: bodyMedium,
      bodySmall: bodySmall,
      labelLarge: labelLarge,
      labelMedium: labelMedium,
      labelSmall: labelSmall,
    );
  }

  static TextStyle _style(
    double size,
    double height,
    FontWeight weight, {
    required Color color,
    bool tabular = false,
  }) {
    return GoogleFonts.inter(
      color: color,
      fontSize: size,
      height: height / size,
      fontWeight: weight,
      fontFeatures: tabular ? const [FontFeature.tabularFigures()] : null,
    );
  }
}
