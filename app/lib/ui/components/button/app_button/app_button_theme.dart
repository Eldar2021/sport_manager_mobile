part of 'app_button.dart';

/// Theme tokens consumed by `AppButton`.
///
/// Register it on a [ThemeData] via `extensions: [AppButtonTheme.fromColorScheme(scheme)]`,
/// or omit it entirely — the widget will fall back to the ambient [ColorScheme].
@immutable
class AppButtonTheme extends ThemeExtension<AppButtonTheme> {
  const AppButtonTheme({
    required this.primaryBackground,
    required this.primaryForeground,
    required this.primaryPressed,
    required this.secondaryBackground,
    required this.secondaryForeground,
    required this.outlineForeground,
    required this.outlineBorder,
    required this.disabledBackground,
    required this.disabledForeground,
    required this.disabledBorder,
    required this.pressedOverlay,
  });

  factory AppButtonTheme.fromColorScheme(ColorScheme scheme) {
    return AppButtonTheme(
      primaryBackground: scheme.primary,
      primaryForeground: scheme.onPrimary,
      primaryPressed: scheme.primaryContainer,
      secondaryBackground: scheme.secondaryContainer,
      secondaryForeground: scheme.onSecondaryContainer,
      outlineForeground: scheme.primary,
      outlineBorder: scheme.outline,
      disabledBackground: scheme.surfaceContainerHighest,
      disabledForeground: scheme.onSurface,
      disabledBorder: scheme.onSurface.withValues(alpha: 0.12),
      pressedOverlay: scheme.onPrimary.withValues(alpha: 0.08),
    );
  }

  final Color primaryBackground;
  final Color primaryForeground;
  final Color primaryPressed;
  final Color secondaryBackground;
  final Color secondaryForeground;
  final Color outlineForeground;
  final Color outlineBorder;
  final Color disabledBackground;
  final Color disabledForeground;
  final Color disabledBorder;
  final Color pressedOverlay;

  // Conventional `.of(context)` lookup — a constructor would be misleading
  // because the result may come from an ambient ThemeExtension or a fallback.
  // ignore: prefer_constructors_over_static_methods
  static AppButtonTheme of(BuildContext context) {
    final theme = Theme.of(context);
    return theme.extension<AppButtonTheme>() ?? AppButtonTheme.fromColorScheme(theme.colorScheme);
  }

  @override
  AppButtonTheme copyWith({
    Color? primaryBackground,
    Color? primaryForeground,
    Color? primaryPressed,
    Color? secondaryBackground,
    Color? secondaryForeground,
    Color? outlineForeground,
    Color? outlineBorder,
    Color? disabledBackground,
    Color? disabledForeground,
    Color? disabledBorder,
    Color? pressedOverlay,
  }) {
    return AppButtonTheme(
      primaryBackground: primaryBackground ?? this.primaryBackground,
      primaryForeground: primaryForeground ?? this.primaryForeground,
      primaryPressed: primaryPressed ?? this.primaryPressed,
      secondaryBackground: secondaryBackground ?? this.secondaryBackground,
      secondaryForeground: secondaryForeground ?? this.secondaryForeground,
      outlineForeground: outlineForeground ?? this.outlineForeground,
      outlineBorder: outlineBorder ?? this.outlineBorder,
      disabledBackground: disabledBackground ?? this.disabledBackground,
      disabledForeground: disabledForeground ?? this.disabledForeground,
      disabledBorder: disabledBorder ?? this.disabledBorder,
      pressedOverlay: pressedOverlay ?? this.pressedOverlay,
    );
  }

  @override
  AppButtonTheme lerp(ThemeExtension<AppButtonTheme>? other, double t) {
    if (other is! AppButtonTheme) return this;
    return AppButtonTheme(
      primaryBackground: Color.lerp(primaryBackground, other.primaryBackground, t)!,
      primaryForeground: Color.lerp(primaryForeground, other.primaryForeground, t)!,
      primaryPressed: Color.lerp(primaryPressed, other.primaryPressed, t)!,
      secondaryBackground: Color.lerp(secondaryBackground, other.secondaryBackground, t)!,
      secondaryForeground: Color.lerp(secondaryForeground, other.secondaryForeground, t)!,
      outlineForeground: Color.lerp(outlineForeground, other.outlineForeground, t)!,
      outlineBorder: Color.lerp(outlineBorder, other.outlineBorder, t)!,
      disabledBackground: Color.lerp(disabledBackground, other.disabledBackground, t)!,
      disabledForeground: Color.lerp(disabledForeground, other.disabledForeground, t)!,
      disabledBorder: Color.lerp(disabledBorder, other.disabledBorder, t)!,
      pressedOverlay: Color.lerp(pressedOverlay, other.pressedOverlay, t)!,
    );
  }
}
