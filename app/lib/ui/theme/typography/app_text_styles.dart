import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract final class AppTextStyles {
  static final TextStyle display = GoogleFonts.inter(
    fontSize: 56,
    height: 64 / 56,
    fontWeight: FontWeight.w700,
    fontFeatures: const [FontFeature.tabularFigures()],
  );

  static final TextStyle h1 = GoogleFonts.inter(
    fontSize: 28,
    height: 34 / 28,
    fontWeight: FontWeight.w700,
  );

  static final TextStyle h2 = GoogleFonts.inter(
    fontSize: 22,
    height: 28 / 22,
    fontWeight: FontWeight.w600,
  );

  static final TextStyle h3 = GoogleFonts.inter(
    fontSize: 18,
    height: 24 / 18,
    fontWeight: FontWeight.w600,
  );

  static final TextStyle body = GoogleFonts.inter(
    fontSize: 16,
    height: 24 / 16,
    fontWeight: FontWeight.w400,
  );

  static final TextStyle bodyBold = GoogleFonts.inter(
    fontSize: 16,
    height: 24 / 16,
    fontWeight: FontWeight.w600,
  );

  static final TextStyle caption = GoogleFonts.inter(
    fontSize: 13,
    height: 18 / 13,
    fontWeight: FontWeight.w500,
  );

  static final TextStyle button = GoogleFonts.inter(
    fontSize: 17,
    height: 22 / 17,
    fontWeight: FontWeight.w600,
  );

  static final TextStyle amount = GoogleFonts.inter(
    fontSize: 32,
    height: 40 / 32,
    fontWeight: FontWeight.w700,
    fontFeatures: const [FontFeature.tabularFigures()],
  );

  static final TextStyle amountSmall = GoogleFonts.inter(
    fontSize: 24,
    height: 32 / 24,
    fontWeight: FontWeight.w700,
    fontFeatures: const [FontFeature.tabularFigures()],
  );
}
