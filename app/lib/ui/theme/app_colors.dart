import 'package:flutter/material.dart';

// Тёплая тема — Warm (amber primary, olive success, stone neutrals)
abstract final class AppColors {
  // Brand — Amber
  static const Color brandAmber = Color(0xFFD97706);      // amber-700
  static const Color brandAmberDark = Color(0xFFB45309);  // amber-800
  static const Color brandAmberLight = Color(0xFFFEF3C7); // amber-100

  // Semantic — Success (Olive)
  static const Color successGreen = Color(0xFF65A30D);    // lime-600
  static const Color successDark = Color(0xFF4D7C0F);     // lime-700
  static const Color successLight = Color(0xFFECFCCB);    // lime-100

  // Semantic — Danger (Red)
  static const Color dangerRed = Color(0xFFDC2626);       // red-600
  static const Color dangerDark = Color(0xFFB91C1C);      // red-700
  static const Color dangerLight = Color(0xFFFEE2E2);     // red-100

  // Semantic — Warning & Info
  static const Color warningAmber = Color(0xFFF59E0B);    // amber-400
  static const Color infoCyan = Color(0xFF0891B2);        // cyan-600

  // Neutrals — Stone (тёплый серый)
  static const Color ink900 = Color(0xFF1C1917);          // stone-900
  static const Color ink700 = Color(0xFF44403C);          // stone-700
  static const Color ink500 = Color(0xFF78716C);          // stone-500
  static const Color ink300 = Color(0xFFD6D3D1);          // stone-300
  static const Color ink100 = Color(0xFFF5F5F4);          // stone-100
  static const Color ink50 = Color(0xFFFAFAF9);           // stone-50
  static const Color white = Color(0xFFFFFFFF);

  // Dark Mode Backgrounds — тёплые тёмные тона
  static const Color darkBgPrimary = Color(0xFF0F0D0B);   // почти чёрный с янтарным оттенком
  static const Color darkBgSecondary = Color(0xFF161310); // карточки, шторки
  static const Color darkBgTertiary = Color(0xFF201B17);  // инпуты, chips
  static const Color darkBgBorder = Color(0xFF2E2825);    // разделители, бордеры

  // Helpers
  static const Color transparent = Color(0x00000000);
  static const Color overlay = Color(0x80000000);
}
