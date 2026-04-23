import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract final class AppTypography {
  // Таймер, большие числа — 56px/700 с tabular-nums
  static final TextStyle display = GoogleFonts.inter(
    fontSize: 56,
    height: 64 / 56,
    fontWeight: FontWeight.w700,
    fontFeatures: const [FontFeature.tabularFigures()],
  );

  // Заголовок экрана — 28px/700
  static final TextStyle h1 = GoogleFonts.inter(
    fontSize: 28,
    height: 34 / 28,
    fontWeight: FontWeight.w700,
  );

  // Заголовок карточки — 22px/600
  static final TextStyle h2 = GoogleFonts.inter(
    fontSize: 22,
    height: 28 / 22,
    fontWeight: FontWeight.w600,
  );

  // Подзаголовок — 18px/600
  static final TextStyle h3 = GoogleFonts.inter(
    fontSize: 18,
    height: 24 / 18,
    fontWeight: FontWeight.w600,
  );

  // Основной текст — 16px/400
  static final TextStyle body = GoogleFonts.inter(
    fontSize: 16,
    height: 24 / 16,
    fontWeight: FontWeight.w400,
  );

  // Жирный основной текст — 16px/600
  static final TextStyle bodyBold = GoogleFonts.inter(
    fontSize: 16,
    height: 24 / 16,
    fontWeight: FontWeight.w600,
  );

  // Метка, вспомогательный текст — 13px/500
  static final TextStyle caption = GoogleFonts.inter(
    fontSize: 13,
    height: 18 / 13,
    fontWeight: FontWeight.w500,
  );

  // Текст кнопки — 17px/600
  static final TextStyle button = GoogleFonts.inter(
    fontSize: 17,
    height: 22 / 17,
    fontWeight: FontWeight.w600,
  );

  // Сумма денег — 32px/700 с tabular-nums
  static final TextStyle amount = GoogleFonts.inter(
    fontSize: 32,
    height: 40 / 32,
    fontWeight: FontWeight.w700,
    fontFeatures: const [FontFeature.tabularFigures()],
  );

  // Маленькая сумма — 24px/700 с tabular-nums
  static final TextStyle amountSmall = GoogleFonts.inter(
    fontSize: 24,
    height: 32 / 24,
    fontWeight: FontWeight.w700,
    fontFeatures: const [FontFeature.tabularFigures()],
  );

  static TextTheme buildTextTheme(Color textColor) {
    return TextTheme(
      // Роли Material3 → наши стили
      displayLarge: display,
      displayMedium: display,
      displaySmall: amount,
      headlineLarge: h1,
      headlineMedium: h2,
      headlineSmall: h3,
      titleLarge: h2, // AppBar title
      titleMedium: h3, // List tiles
      titleSmall: bodyBold,
      bodyLarge: bodyBold,
      bodyMedium: body,
      bodySmall: caption,
      labelLarge: button, // ElevatedButton, FilledButton
      labelMedium: caption,
      labelSmall: caption,
    ).apply(bodyColor: textColor, displayColor: textColor);
  }
}
