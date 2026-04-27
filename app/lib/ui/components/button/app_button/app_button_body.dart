part of 'app_button.dart';

/// Internal layer that turns a normalized `0.0..1.0` animation value into the
/// actual button widget.
///
/// - `t == 0` → full-width expanded state
/// - `t == 1` → square collapsed state (width == height)
/// - in between → linearly interpolated width with a crossfade between
///   [AppButtonContent] and [collapsedIcon]
class AppButtonBody extends StatelessWidget {
  const AppButtonBody({
    required this.animation,
    required this.sizeConfig,
    required this.variant,
    required this.theme,
    required this.style,
    required this.onPressed,
    required this.isLoading,
    required this.expand,
    required this.child,
    this.leading,
    this.trailing,
    this.collapsedIcon,
    this.autofocus = false,
    this.focusNode,
    this.semanticLabel,
    super.key,
  });

  final Animation<double> animation;
  final AppButtonSizeConfig sizeConfig;
  final AppButtonVariant variant;
  final AppButtonTheme theme;
  final ButtonStyle style;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool expand;
  final Widget child;
  final Widget? leading;
  final Widget? trailing;
  final Widget? collapsedIcon;
  final bool autofocus;
  final FocusNode? focusNode;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final disabledStates = onPressed == null ? const <WidgetState>{WidgetState.disabled} : const <WidgetState>{};
    final foreground = AppButtonStyle.foregroundOf(
      variant: variant,
      theme: theme,
      states: disabledStates,
    );

    final expandedContent = isLoading
        ? AppButtonLoadingIndicator(
            size: sizeConfig.loadingIndicatorSize,
            color: foreground,
          )
        : AppButtonContent(
            sizeConfig: sizeConfig,
            leading: leading,
            trailing: trailing,
            child: child,
          );

    final collapsedContent = isLoading
        ? AppButtonLoadingIndicator(
            size: sizeConfig.loadingIndicatorSize,
            color: foreground,
          )
        : collapsedIcon ??
              Icon(
                Icons.arrow_forward,
                size: sizeConfig.iconSize,
              );

    return Semantics(
      container: true,
      button: true,
      enabled: onPressed != null,
      label: semanticLabel,
      child: AnimatedBuilder(
        animation: animation,
        builder: (context, _) {
          return Align(
            alignment: AlignmentGeometry.bottomRight,
            child: _AnimatedFrame(
              t: animation.value,
              height: sizeConfig.height,
              expand: expand,
              child: _MaterialButtonFor(
                variant: variant,
                style: style,
                onPressed: onPressed,
                autofocus: autofocus,
                focusNode: focusNode,
                child: _CrossfadeContent(
                  t: animation.value,
                  expanded: expandedContent,
                  collapsed: collapsedContent,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _AnimatedFrame extends StatelessWidget {
  const _AnimatedFrame({
    required this.t,
    required this.height,
    required this.expand,
    required this.child,
  });

  final double t;
  final double height;
  final bool expand;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (!expand) return child;

    if (t == 1) {
      return SizedBox(
        width: height,
        height: height,
        child: child,
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth.isFinite ? constraints.maxWidth : height;
        final width = lerpDouble(maxWidth, height, t)!;

        return SizedBox(
          width: width,
          height: height,
          child: child,
        );
      },
    );
  }
}

class _CrossfadeContent extends StatelessWidget {
  const _CrossfadeContent({
    required this.t,
    required this.expanded,
    required this.collapsed,
  });

  final double t;
  final Widget expanded;
  final Widget collapsed;

  @override
  Widget build(BuildContext context) {
    if (t == 0) return expanded;
    if (t == 1) return collapsed;

    return Stack(
      alignment: Alignment.center,
      children: [
        Opacity(
          opacity: (1 - t).clamp(0.0, 1.0),
          child: expanded,
        ),
        Opacity(
          opacity: t.clamp(0.0, 1.0),
          child: collapsed,
        ),
      ],
    );
  }
}

class _MaterialButtonFor extends StatelessWidget {
  const _MaterialButtonFor({
    required this.variant,
    required this.style,
    required this.onPressed,
    required this.autofocus,
    required this.focusNode,
    required this.child,
  });

  final AppButtonVariant variant;
  final ButtonStyle style;
  final VoidCallback? onPressed;
  final bool autofocus;
  final FocusNode? focusNode;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return switch (variant) {
      AppButtonVariant.outline => OutlinedButton(
        onPressed: onPressed,
        style: style,
        autofocus: autofocus,
        focusNode: focusNode,
        child: child,
      ),
      _ => ElevatedButton(
        onPressed: onPressed,
        style: style,
        autofocus: autofocus,
        focusNode: focusNode,
        child: child,
      ),
    };
  }
}
