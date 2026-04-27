part of 'app_button.dart';

/// Pure functions that translate ([AppButtonVariant], [AppButtonTheme],
/// [WidgetState]) into a [ButtonStyle].
///
/// All methods are static and side-effect free, so callers can cache the
/// result for the lifetime of a widget.
abstract final class AppButtonStyle {
  static Color backgroundOf({
    required AppButtonVariant variant,
    required AppButtonTheme theme,
    required Set<WidgetState> states,
  }) {
    final isDisabled = states.contains(WidgetState.disabled);
    final isPressed = states.contains(WidgetState.pressed);

    return switch (variant) {
      AppButtonVariant.primary => switch ((isDisabled, isPressed)) {
        (true, _) => theme.disabledBackground,
        (false, true) => theme.primaryPressed,
        _ => theme.primaryBackground,
      },
      AppButtonVariant.secondary => isDisabled ? theme.disabledBackground : theme.secondaryBackground,
      AppButtonVariant.outline => Colors.transparent,
    };
  }

  static Color foregroundOf({
    required AppButtonVariant variant,
    required AppButtonTheme theme,
    required Set<WidgetState> states,
  }) {
    final isDisabled = states.contains(WidgetState.disabled);

    return switch (variant) {
      AppButtonVariant.primary => isDisabled ? theme.disabledForeground : theme.primaryForeground,
      AppButtonVariant.secondary => isDisabled ? theme.disabledForeground : theme.secondaryForeground,
      AppButtonVariant.outline => isDisabled ? theme.disabledForeground : theme.outlineForeground,
    };
  }

  static BorderSide? borderOf({
    required AppButtonVariant variant,
    required AppButtonTheme theme,
    required Set<WidgetState> states,
  }) {
    if (variant != AppButtonVariant.outline) return null;
    final isDisabled = states.contains(WidgetState.disabled);
    return BorderSide(
      color: isDisabled ? theme.disabledBorder : theme.outlineBorder,
      width: 1.2,
    );
  }

  static ButtonStyle resolve({
    required AppButtonVariant variant,
    required AppButtonSizeConfig sizeConfig,
    required AppButtonTheme theme,
  }) {
    return ButtonStyle(
      minimumSize: WidgetStatePropertyAll(
        Size(sizeConfig.height, sizeConfig.height),
      ),
      maximumSize: const WidgetStatePropertyAll(Size.infinite),
      padding: WidgetStatePropertyAll(
        EdgeInsets.symmetric(
          horizontal: sizeConfig.horizontalPadding,
        ),
      ),
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(sizeConfig.borderRadius),
        ),
      ),
      side: WidgetStateProperty.resolveWith(
        (states) => borderOf(
          variant: variant,
          theme: theme,
          states: states,
        ),
      ),
      backgroundColor: WidgetStateProperty.resolveWith(
        (states) => backgroundOf(
          variant: variant,
          theme: theme,
          states: states,
        ),
      ),
      foregroundColor: WidgetStateProperty.resolveWith(
        (states) => foregroundOf(
          variant: variant,
          theme: theme,
          states: states,
        ),
      ),
      overlayColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.pressed)) return theme.pressedOverlay;
        return null;
      }),
      elevation: const WidgetStatePropertyAll(0),
      textStyle: WidgetStatePropertyAll(
        TextStyle(
          fontSize: sizeConfig.fontSize,
          fontWeight: sizeConfig.fontWeight,
        ),
      ),
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity.standard,
      animationDuration: Duration.zero,
    );
  }
}
