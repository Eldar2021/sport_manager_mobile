import 'package:flutter/material.dart';

/// Tüm uygulama renklerinin tek kaynağı.
///
/// Figma'dan gelen bir hex değerinin yerini bulmak için bu dosyada arayın.
/// Her sabitin üstündeki yorum, rengin tema sisteminde nereden okunduğunu
/// söyler — geliştirici constant yerine `Theme.of(context)` veya
/// `AppColorsExt` üzerinden erişebilir.
///
/// Erişim kuralları:
/// - `colorScheme.X` → `context.colors.X`
/// - `appColorsExt.X` → `context.appColors.X`
/// - `AppShadow.X` → doğrudan token, `context.appColors.shadowX` ile theme-aware
abstract final class AppColors {
  /// Marka birincil rengi.
  /// → `colorScheme.primary` (light + dark)
  static const Color brandAmber = Color(0xFFD97706);

  /// Marka koyu varyantı.
  /// → `colorScheme.primaryContainer` (dark) / `colorScheme.onPrimaryContainer` (light)
  /// → `colorScheme.inversePrimary` (dark)
  static const Color brandAmberDark = Color(0xFFB45309);

  /// Marka açık varyantı.
  /// → `colorScheme.primaryContainer` (light) / `colorScheme.onPrimaryContainer` (dark)
  /// → `colorScheme.inversePrimary` (light)
  static const Color brandAmberLight = Color(0xFFFEF3C7);

  /// Marka yumuşak overlay (light) — NavigationBar indicator'ında kullanılır.
  /// → `appColors.brandAmberSoft` (light)
  static const Color brandAmberSoftLight = Color(0x20D97706);

  /// Marka yumuşak overlay (dark).
  /// → `appColors.brandAmberSoft` (dark)
  static const Color brandAmberSoftDark = Color(0x33D97706);

  /// → `colorScheme.secondary` (light + dark)
  /// → `appColors.success`
  static const Color successGreen = Color(0xFF65A30D);

  /// → `colorScheme.secondaryContainer` (dark) / `colorScheme.onSecondaryContainer` (light)
  /// → `appColors.successContainer` (dark) / `appColors.onSuccessContainer` (light)
  static const Color successDark = Color(0xFF4D7C0F);

  /// → `colorScheme.secondaryContainer` (light) / `colorScheme.onSecondaryContainer` (dark)
  /// → `appColors.successContainer` (light) / `appColors.onSuccessContainer` (dark)
  static const Color successLight = Color(0xFFECFCCB);

  /// Tehlike / hata rengi.
  /// → `colorScheme.error` (light + dark)
  static const Color dangerRed = Color(0xFFDC2626);

  /// Tehlike koyu varyantı.
  /// → `colorScheme.errorContainer` (dark) / `colorScheme.onErrorContainer` (light)
  static const Color dangerDark = Color(0xFFB91C1C);

  /// Tehlike açık varyantı.
  /// → `colorScheme.errorContainer` (light) / `colorScheme.onErrorContainer` (dark)
  static const Color dangerLight = Color(0xFFFEE2E2);

  /// Uyarı rengi.
  /// → `appColors.warning`
  static const Color warningAmber = Color(0xFFF59E0B);

  /// Uyarı açık varyantı.
  /// → `appColors.warningContainer` (light)
  static const Color warningLight = Color(0xFFFEF3C7);

  /// Bilgi rengi.
  /// → `colorScheme.tertiary` (light + dark)
  /// → `appColors.info`
  static const Color infoCyan = Color(0xFF0891B2);

  /// Bilgi açık varyantı.
  /// → `colorScheme.tertiaryContainer` (light)
  /// → `appColors.infoContainer` (light)
  static const Color infoLight = Color(0xFFCFFAFE);

  /// En koyu metin / yüzey.
  /// → `colorScheme.onSurface` (light)
  /// → `colorScheme.inverseSurface` (light)
  /// → `appColors.onWarning`
  static const Color ink900 = Color(0xFF1C1917);

  /// İkincil metin (light).
  /// → `colorScheme.outlineVariant` (dark)
  static const Color ink700 = Color(0xFF44403C);

  /// Yardımcı metin / disabled.
  /// → `colorScheme.onSurfaceVariant` (light)
  static const Color ink500 = Color(0xFF78716C);

  /// Border / disabled-bg (light).
  /// → `colorScheme.outline` (light)
  /// → `colorScheme.onSurfaceVariant` (dark)
  static const Color ink300 = Color(0xFFD6D3D1);

  /// Yumuşak yüzey (light).
  /// → `colorScheme.surfaceContainerHigh / surfaceContainerHighest` (light)
  /// → `colorScheme.outlineVariant` (light)
  /// → `colorScheme.inverseSurface` (dark)
  static const Color ink100 = Color(0xFFF5F5F4);

  /// En açık nötr ton (yedek; doğrudan ColorScheme'de kullanılmıyor).
  static const Color ink50 = Color(0xFFFAFAF9);

  /// Beyaz.
  /// → `colorScheme.onPrimary / onSecondary / onError / onTertiary`
  /// → `colorScheme.onInverseSurface` (light)
  /// → `colorScheme.surface / surfaceContainer / surfaceContainerLowest / surfaceContainerLow` (light)
  /// → `colorScheme.onSurface` (dark)
  static const Color white = Color(0xFFFFFFFF);

  /// Saf siyah — `colorScheme.shadow / scrim`.
  static const Color black = Color(0xFF000000);

  /// Şeffaf — surfaceTint'lerde, statusBar'da, transparent yüzeylerde.
  static const Color transparent = Color(0x00000000);

  /// Modal / scrim overlay (50% black).
  static const Color overlay = Color(0x80000000);

  /// Dark mode scaffold arka planı.
  /// → `colorScheme.surfaceContainerLow / surfaceContainerLowest` (dark)
  /// → Scaffold background (dark)
  static const Color darkBgPrimary = Color(0xFF0F0D0B);

  /// Dark mode kart / sheet / dialog yüzeyi.
  /// → `colorScheme.surface / surfaceContainer / surfaceContainerHigh` (dark)
  static const Color darkBgSecondary = Color(0xFF161310);

  /// Dark mode chip / input / tonal-button yüzeyi.
  /// → `colorScheme.surfaceContainerHighest` (dark)
  static const Color darkBgTertiary = Color(0xFF201B17);

  /// Dark mode border / divider.
  /// → `colorScheme.outline` (dark)
  static const Color darkBgBorder = Color(0xFF2E2825);

  /// Light mode scaffold arka planı (ılık off-white).
  /// → `colorScheme.surfaceContainerLow` (light)
  /// → Scaffold background (light)
  static const Color bgWarm = Color(0xFFFAF6F0);

  /// Hafif gölge (light) — sm.
  /// → `AppShadow.smLight`
  static const Color shadowSmLight = Color(0x0A000000);

  /// Orta gölge (light) — md.
  /// → `AppShadow.mdLight`
  static const Color shadowMdLight = Color(0x14000000);

  /// Belirgin gölge (light) — lg.
  /// → `AppShadow.lgLight`
  static const Color shadowLgLight = Color(0x1F000000);

  /// Hafif gölge (dark) — koyu yüzeylerde daha yoğun siyah.
  /// → `AppShadow.smDark`
  static const Color shadowSmDark = Color(0x33000000);

  /// Orta gölge (dark).
  /// → `AppShadow.mdDark`
  static const Color shadowMdDark = Color(0x47000000);

  /// Belirgin gölge (dark).
  /// → `AppShadow.lgDark`
  static const Color shadowLgDark = Color(0x66000000);
}
