import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sport_manager_mobile/ui/theme/app_colors.dart';
import 'package:sport_manager_mobile/ui/theme/app_spacing.dart';
import 'package:sport_manager_mobile/ui/theme/app_typography.dart';

abstract final class AppTheme {
  static ThemeData get dark => _buildDark();
  static ThemeData get light => _buildLight();

  // ---------------------------------------------------------------------------
  // Тёплая Dark ColorScheme
  // ---------------------------------------------------------------------------

  static const ColorScheme _darkColorScheme = ColorScheme(
    brightness: Brightness.dark,

    // Primary — Amber
    primary: AppColors.brandAmber,
    onPrimary: AppColors.white,
    primaryContainer: AppColors.brandAmberDark,
    onPrimaryContainer: AppColors.brandAmberLight,

    // Secondary — Olive (свободный стол / начать)
    secondary: AppColors.successGreen,
    onSecondary: AppColors.white,
    secondaryContainer: AppColors.successDark,
    onSecondaryContainer: AppColors.white,

    // Tertiary — Cyan (инфо)
    tertiary: AppColors.infoCyan,
    onTertiary: AppColors.white,
    tertiaryContainer: AppColors.infoCyan,
    onTertiaryContainer: AppColors.white,

    // Error — Red (занятый стол / завершить)
    error: AppColors.dangerRed,
    onError: AppColors.white,
    errorContainer: AppColors.dangerDark,
    onErrorContainer: AppColors.white,

    // Surfaces
    surface: AppColors.darkBgSecondary,
    onSurface: AppColors.white,
    onSurfaceVariant: AppColors.ink300,

    surfaceContainerLowest: AppColors.darkBgPrimary,
    surfaceContainerLow: AppColors.darkBgPrimary,
    surfaceContainer: AppColors.darkBgSecondary,
    surfaceContainerHigh: AppColors.darkBgSecondary,
    surfaceContainerHighest: AppColors.darkBgTertiary,

    // Бордеры
    outline: AppColors.darkBgBorder,
    outlineVariant: AppColors.ink700,

    // Misc
    shadow: Colors.black,
    scrim: Colors.black,
    inverseSurface: AppColors.ink100,
    onInverseSurface: AppColors.ink900,
    inversePrimary: AppColors.brandAmberDark,
    surfaceTint: AppColors.brandAmber,
  );

  // ---------------------------------------------------------------------------
  // Dark Theme
  // ---------------------------------------------------------------------------

  static ThemeData _buildDark() {
    final textTheme = AppTypography.buildTextTheme(AppColors.white);
    const cs = _darkColorScheme;

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: cs,
      scaffoldBackgroundColor: AppColors.darkBgPrimary,
      textTheme: textTheme,

      // AppBar
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.darkBgPrimary,
        foregroundColor: AppColors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle.light.copyWith(
          statusBarColor: AppColors.transparent,
        ),
        titleTextStyle: textTheme.titleLarge?.copyWith(color: AppColors.white),
        iconTheme: const IconThemeData(color: AppColors.white),
      ),

      // Card
      cardTheme: const CardThemeData(
        color: AppColors.darkBgSecondary,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.cardBorderRadius),
        margin: EdgeInsets.zero,
      ),

      // ElevatedButton
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: cs.primary,
          foregroundColor: cs.onPrimary,
          disabledBackgroundColor: AppColors.ink700,
          disabledForegroundColor: AppColors.ink500,
          elevation: 0,
          shape: const RoundedRectangleBorder(borderRadius: AppRadius.buttonBorderRadius),
          minimumSize: const Size(double.infinity, 56),
          textStyle: AppTypography.button,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x4, vertical: AppSpacing.x4),
        ),
      ),

      // FilledButton
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: cs.primary,
          foregroundColor: cs.onPrimary,
          disabledBackgroundColor: AppColors.ink700,
          disabledForegroundColor: AppColors.ink500,
          elevation: 0,
          shape: const RoundedRectangleBorder(borderRadius: AppRadius.buttonBorderRadius),
          minimumSize: const Size(double.infinity, 56),
          textStyle: AppTypography.button,
        ),
      ),

      // OutlinedButton
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: cs.primary,
          disabledForegroundColor: AppColors.ink500,
          side: const BorderSide(color: AppColors.darkBgBorder),
          shape: const RoundedRectangleBorder(borderRadius: AppRadius.buttonBorderRadius),
          minimumSize: const Size(double.infinity, 56),
          textStyle: AppTypography.button,
        ),
      ),

      // TextButton
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: cs.primary,
          disabledForegroundColor: AppColors.ink500,
          shape: const RoundedRectangleBorder(borderRadius: AppRadius.buttonBorderRadius),
          textStyle: AppTypography.button,
        ),
      ),

      // Input
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.darkBgTertiary,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.x4,
          vertical: AppSpacing.x4,
        ),
        border: const OutlineInputBorder(
          borderRadius: AppRadius.inputBorderRadius,
          borderSide: BorderSide(color: AppColors.darkBgBorder),
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: AppRadius.inputBorderRadius,
          borderSide: BorderSide(color: AppColors.darkBgBorder),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: AppRadius.inputBorderRadius,
          borderSide: BorderSide(color: AppColors.brandAmber, width: 1.5),
        ),
        errorBorder: const OutlineInputBorder(
          borderRadius: AppRadius.inputBorderRadius,
          borderSide: BorderSide(color: AppColors.dangerRed),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderRadius: AppRadius.inputBorderRadius,
          borderSide: BorderSide(color: AppColors.dangerRed, width: 1.5),
        ),
        hintStyle: AppTypography.body.copyWith(color: AppColors.ink500),
        labelStyle: AppTypography.body.copyWith(color: AppColors.ink300),
        errorStyle: AppTypography.caption.copyWith(color: AppColors.dangerRed),
      ),

      // BottomSheet
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.darkBgSecondary,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.modalBorderRadius),
        showDragHandle: true,
        dragHandleColor: AppColors.ink700,
      ),

      // Dialog
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.darkBgSecondary,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(AppRadius.modal)),
        ),
        titleTextStyle: textTheme.headlineSmall?.copyWith(color: AppColors.white),
        contentTextStyle: textTheme.bodyMedium?.copyWith(color: AppColors.ink300),
      ),

      // Chip
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.darkBgTertiary,
        selectedColor: AppColors.brandAmber,
        disabledColor: AppColors.ink700,
        labelStyle: AppTypography.caption.copyWith(color: AppColors.ink300),
        secondaryLabelStyle: AppTypography.caption.copyWith(color: AppColors.white),
        side: const BorderSide(color: AppColors.darkBgBorder),
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.chipBorderRadius),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x3, vertical: AppSpacing.x1),
      ),

      // Divider
      dividerTheme: const DividerThemeData(
        color: AppColors.darkBgBorder,
        thickness: 1,
        space: 1,
      ),

      // SnackBar
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.darkBgTertiary,
        contentTextStyle: AppTypography.body.copyWith(color: AppColors.white),
        actionTextColor: AppColors.brandAmber,
        behavior: SnackBarBehavior.floating,
        elevation: 0,
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.cardBorderRadius),
      ),

      // ListTile
      listTileTheme: const ListTileThemeData(
        tileColor: Colors.transparent,
        textColor: AppColors.white,
        iconColor: AppColors.ink300,
        contentPadding: EdgeInsets.symmetric(horizontal: AppSpacing.x4),
        shape: RoundedRectangleBorder(borderRadius: AppRadius.cardBorderRadius),
      ),

      // Switch
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return AppColors.white;
          return AppColors.ink500;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return AppColors.brandAmber;
          return AppColors.darkBgTertiary;
        }),
        trackOutlineColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return Colors.transparent;
          return AppColors.darkBgBorder;
        }),
      ),

      // ProgressIndicator
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.brandAmber,
        linearTrackColor: AppColors.darkBgTertiary,
        circularTrackColor: AppColors.darkBgTertiary,
      ),

      // NavigationBar
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.darkBgSecondary,
        indicatorColor: const Color(0x33D97706), // brandAmber с 20% opacity
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: AppColors.brandAmber);
          }
          return const IconThemeData(color: AppColors.ink500);
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppTypography.caption.copyWith(color: AppColors.brandAmber);
          }
          return AppTypography.caption.copyWith(color: AppColors.ink500);
        }),
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),

      // PopupMenu
      popupMenuTheme: PopupMenuThemeData(
        color: AppColors.darkBgSecondary,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: AppRadius.cardBorderRadius,
          side: BorderSide(color: AppColors.darkBgBorder),
        ),
        textStyle: AppTypography.body.copyWith(color: AppColors.white),
      ),

      // Tooltip
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: AppColors.darkBgTertiary,
          borderRadius: AppRadius.chipBorderRadius,
          border: Border.all(color: AppColors.darkBgBorder),
        ),
        textStyle: AppTypography.caption.copyWith(color: AppColors.white),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Light Theme — заглушка, будет расширена позже
  // ---------------------------------------------------------------------------

  static ThemeData _buildLight() {
    final textTheme = AppTypography.buildTextTheme(AppColors.ink900);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(seedColor: AppColors.brandAmber),
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle.dark.copyWith(
          statusBarColor: AppColors.transparent,
        ),
        titleTextStyle: textTheme.titleLarge,
      ),
    );
  }
}
