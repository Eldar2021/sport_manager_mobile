import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Uygulamanın tüm metin stilleri. Tek bir renge göre üretilir
/// (`AppTextTheme.from(color)`); aynı yapı `AppTextThemeExt` içinde
/// error / disabled / muted varyantları için yeniden kullanılır.
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

  final TextStyle displayLarge;
  final TextStyle displayMedium;
  final TextStyle displaySmall;
  final TextStyle headlineLarge;
  final TextStyle headlineMedium;
  final TextStyle headlineSmall;
  final TextStyle titleLarge;
  final TextStyle titleMedium;
  final TextStyle titleSmall;
  final TextStyle bodyLarge;
  final TextStyle bodyMedium;
  final TextStyle bodySmall;
  final TextStyle labelLarge;
  final TextStyle labelMedium;
  final TextStyle labelSmall;

  /// Para tutarları için tabular-nums 24px varyantı (Material rollerinde yok).
  final TextStyle amountSmall;

  /// Material 3 [TextTheme]'e dönüştürür — `ThemeData(textTheme: ...)` için.
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
