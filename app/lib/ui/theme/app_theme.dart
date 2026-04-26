import 'package:flutter/material.dart';
import 'package:sport_manager_mobile/ui/theme/colors/app_colors.dart';
import 'package:sport_manager_mobile/ui/theme/colors/app_colors_extension.dart';
import 'package:sport_manager_mobile/ui/theme/colors/color_schemes.dart';
import 'package:sport_manager_mobile/ui/theme/components/components.dart';
import 'package:sport_manager_mobile/ui/theme/typography/app_text_theme.dart';
import 'package:sport_manager_mobile/ui/theme/typography/app_text_theme_extension.dart';

abstract final class AppTheme {
  static ThemeData get light => _build(
    colors: AppColorSchemes.light,
    appColors: AppColorsExt.light,
    scaffoldBackground: AppColors.bgWarm,
  );

  static ThemeData get dark => _build(
    colors: AppColorSchemes.dark,
    appColors: AppColorsExt.dark,
    scaffoldBackground: AppColors.darkBgPrimary,
  );

  static ThemeData _build({
    required ColorScheme colors,
    required AppColorsExt appColors,
    required Color scaffoldBackground,
  }) {
    final appTextTheme = AppTextTheme.from(colors.onSurface);
    final textTheme = appTextTheme.toMaterialTextTheme();
    final textThemeExt = AppTextThemeExt.from(colors: colors);

    return ThemeData(
      useMaterial3: true,
      brightness: colors.brightness,
      colorScheme: colors,
      scaffoldBackgroundColor: scaffoldBackground,
      textTheme: textTheme,
      extensions: [appColors, textThemeExt],
      appBarTheme: AppBarComponentTheme.build(colors, textTheme),
      cardTheme: CardComponentTheme.build(colors),
      filledButtonTheme: ButtonComponentTheme.filled(colors, textTheme),
      elevatedButtonTheme: ButtonComponentTheme.elevated(colors, textTheme),
      outlinedButtonTheme: ButtonComponentTheme.outlined(colors, textTheme),
      textButtonTheme: ButtonComponentTheme.text(colors, textTheme),
      inputDecorationTheme: InputComponentTheme.build(colors, textTheme),
      bottomSheetTheme: BottomSheetComponentTheme.build(colors),
      dialogTheme: DialogComponentTheme.build(colors, textTheme),
      chipTheme: ChipComponentTheme.build(colors, textTheme),
      dividerTheme: DividerComponentTheme.build(colors),
      snackBarTheme: SnackbarComponentTheme.build(colors, textTheme),
      listTileTheme: ListTileComponentTheme.build(colors),
      switchTheme: SwitchComponentTheme.build(colors),
      progressIndicatorTheme: ProgressIndicatorComponentTheme.build(colors),
      navigationBarTheme: NavigationBarComponentTheme.build(colors, textTheme, appColors),
      popupMenuTheme: PopupMenuComponentTheme.build(colors, textTheme),
      tooltipTheme: TooltipComponentTheme.build(colors, textTheme),
    );
  }
}
