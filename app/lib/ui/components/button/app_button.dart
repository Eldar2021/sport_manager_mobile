import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

/// Visual variants of [AppButton]. Each maps to a Material variant whose
/// colors are already wired in `ButtonComponentTheme` — we don't introduce
/// a parallel theme extension.
///
/// - [primary]   high-emphasis CTA       → [FilledButton]
/// - [secondary] tonal mid-emphasis      → [FilledButton.tonal]
/// - [outline]   low-emphasis with rim   → [OutlinedButton]
enum AppButtonVariant { primary, secondary, outline }

/// Predefined sizes. Heights map to design tokens
/// ([AppSpacing.x10] / [AppSpacing.x12] / [AppSpacing.x14]).
enum AppButtonSize { small, medium, large }

/// A themeable button with three variants × three sizes, a loading state, an
/// optional leading/trailing slot, and an optional collapse-on-scroll behavior
/// driven by an ambient `AppButtonScope` (e.g. shrink to a square FAB while
/// the keyboard is open).
///
/// For typical form submissions, prefer:
/// ```dart
/// AppButton(
///   onPressed: _submit,
///   isLoading: state.isLoading,
///   child: Text(context.l10n.authSignIn),
/// )
/// ```
class AppButton extends StatefulWidget {
  const AppButton({
    required this.child,
    this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.size = AppButtonSize.large,
    this.isLoading = false,
    this.leading,
    this.trailing,
    this.semanticLabel,
    this.autofocus = false,
    this.focusNode,
    this.expand = true,
    this.collapseOnScroll = false,
    this.collapsedIcon,
    this.animationDuration = const Duration(milliseconds: 250),
    super.key,
  }) : assert(
         !collapseOnScroll || expand,
         'collapseOnScroll requires expand=true so the button has a width to collapse from.',
       );

  /// Primary content. Usually a [Text]; can be any widget.
  final Widget child;

  /// Tap callback. `null` puts the button in its disabled state. Calls are
  /// also suppressed while [isLoading] is `true`.
  final VoidCallback? onPressed;

  final AppButtonVariant variant;
  final AppButtonSize size;

  /// Replaces [child] with a sized circular spinner; suppresses [onPressed].
  final bool isLoading;

  /// Optional widgets shown inside the row, on either side of [child].
  final Widget? leading;
  final Widget? trailing;

  final String? semanticLabel;
  final bool autofocus;
  final FocusNode? focusNode;

  /// `true` stretches the button to the parent's max width; `false` hugs the
  /// content.
  final bool expand;

  /// When `true`, the button shrinks to a square FAB-like shape while the
  /// nearest `AppButtonScope` reports `collapsed: true` (the keyboard is open
  /// or its scrollable scrolled past the threshold). No-op without an ambient
  /// scope.
  final bool collapseOnScroll;

  /// Widget shown in the collapsed state. Defaults to [Icons.arrow_forward].
  final Widget? collapsedIcon;

  final Duration animationDuration;

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: widget.animationDuration);
    _animation = CurvedAnimation(parent: _animationController, curve: Curves.easeInOut);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _syncAnimationToScope();
  }

  @override
  void didUpdateWidget(covariant AppButton oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.animationDuration != oldWidget.animationDuration) {
      _animationController.duration = widget.animationDuration;
    }
    if (widget.collapseOnScroll != oldWidget.collapseOnScroll) {
      _syncAnimationToScope();
    }
  }

  void _syncAnimationToScope() {
    if (!widget.collapseOnScroll) {
      _animationController.reverse();
      return;
    }
    final collapsed = AppButtonScope.maybeCollapsedOf(context) ?? false;
    if (collapsed) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  VoidCallback? get _effectiveOnPressed => widget.isLoading ? null : widget.onPressed;

  @override
  Widget build(BuildContext context) {
    final spec = _SizeSpec.of(widget.size);
    final textStyle = _textStyleFor(widget.size, context.textTheme);
    final style = _buildStyle(spec, textStyle);

    return Semantics(
      container: true,
      button: true,
      enabled: _effectiveOnPressed != null,
      label: widget.semanticLabel,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, _) {
          return Align(
            alignment: Alignment.centerRight,
            heightFactor: 1,
            child: _SizedFrame(
              t: _animation.value,
              height: spec.height,
              expand: widget.expand,
              child: _MaterialFor(
                variant: widget.variant,
                style: style,
                onPressed: _effectiveOnPressed,
                autofocus: widget.autofocus,
                focusNode: widget.focusNode,
                child: _CrossfadeContent(
                  t: _animation.value,
                  expanded: _expandedChild(spec),
                  collapsed: _collapsedChild(spec),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  ButtonStyle _buildStyle(_SizeSpec spec, TextStyle? textStyle) {
    return ButtonStyle(
      minimumSize: WidgetStatePropertyAll(
        widget.expand ? Size(double.infinity, spec.height) : Size(spec.height, spec.height),
      ),
      maximumSize: const WidgetStatePropertyAll(Size.infinite),
      padding: WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: spec.horizontalPadding)),
      shape: const WidgetStatePropertyAll(
        RoundedRectangleBorder(borderRadius: AppRadius.buttonBorderRadius),
      ),
      textStyle: WidgetStatePropertyAll(textStyle),
    );
  }

  Widget _expandedChild(_SizeSpec spec) {
    if (widget.isLoading) return _LoadingIndicator(size: spec.loadingSize);
    return _Content(spec: spec, leading: widget.leading, trailing: widget.trailing, child: widget.child);
  }

  Widget _collapsedChild(_SizeSpec spec) {
    if (widget.isLoading) return _LoadingIndicator(size: spec.loadingSize);
    return widget.collapsedIcon ?? Icon(Icons.arrow_forward, size: spec.iconSize);
  }
}

enum _SizeSpec {
  small(
    height: AppSpacing.x10,
    horizontalPadding: AppSpacing.x3,
    iconSize: AppSpacing.x4,
    iconGap: AppSpacing.x2,
    loadingSize: AppSpacing.x4,
  ),
  medium(
    height: AppSpacing.x12,
    horizontalPadding: AppSpacing.x4,
    iconSize: AppSpacing.x5,
    iconGap: AppSpacing.x2,
    loadingSize: AppSpacing.x5,
  ),
  large(
    height: AppSpacing.x14,
    horizontalPadding: AppSpacing.x5,
    iconSize: AppSpacing.x5,
    iconGap: AppSpacing.x2,
    loadingSize: AppSpacing.x5,
  )
  ;

  const _SizeSpec({
    required this.height,
    required this.horizontalPadding,
    required this.iconSize,
    required this.iconGap,
    required this.loadingSize,
  });

  final double height;
  final double horizontalPadding;
  final double iconSize;
  final double iconGap;
  final double loadingSize;

  static _SizeSpec of(AppButtonSize size) => switch (size) {
    AppButtonSize.small => _SizeSpec.small,
    AppButtonSize.medium => _SizeSpec.medium,
    AppButtonSize.large => _SizeSpec.large,
  };
}

TextStyle? _textStyleFor(AppButtonSize size, TextTheme textTheme) {
  return switch (size) {
    AppButtonSize.small => textTheme.labelMedium,
    AppButtonSize.medium || AppButtonSize.large => textTheme.labelLarge,
  };
}

/// Row of `[leading?] child [trailing?]`. Icon and text colors come from the
/// inherited [IconTheme] / [DefaultTextStyle], which the underlying Material
/// button sets — callers don't need to thread colors through.
class _Content extends StatelessWidget {
  const _Content({
    required this.spec,
    required this.child,
    this.leading,
    this.trailing,
  });

  final _SizeSpec spec;
  final Widget child;
  final Widget? leading;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final iconData = IconThemeData(size: spec.iconSize);
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (leading != null) ...[
          IconTheme.merge(data: iconData, child: leading!),
          SizedBox(width: spec.iconGap),
        ],
        Flexible(child: child),
        if (trailing != null) ...[
          SizedBox(width: spec.iconGap),
          IconTheme.merge(data: iconData, child: trailing!),
        ],
      ],
    );
  }
}

class _LoadingIndicator extends StatelessWidget {
  const _LoadingIndicator({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    final color = DefaultTextStyle.of(context).style.color ?? IconTheme.of(context).color;
    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        valueColor: AlwaysStoppedAnimation<Color?>(color),
      ),
    );
  }
}

/// Sizes the surrounding box. `t == 0` → full expanded width; `t == 1` →
/// square (width == height); in between → linear interpolation.
class _SizedFrame extends StatelessWidget {
  const _SizedFrame({
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
      return SizedBox(width: height, height: height, child: child);
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth.isFinite ? constraints.maxWidth : height;
        final width = lerpDouble(maxWidth, height, t)!;
        return SizedBox(width: width, height: height, child: child);
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
        Opacity(opacity: (1 - t).clamp(0.0, 1.0), child: expanded),
        Opacity(opacity: t.clamp(0.0, 1.0), child: collapsed),
      ],
    );
  }
}

/// Picks the Material variant for the requested [AppButtonVariant]. Each
/// variant inherits its colors from the global [ButtonComponentTheme].
class _MaterialFor extends StatelessWidget {
  const _MaterialFor({
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
      AppButtonVariant.primary => FilledButton(
        onPressed: onPressed,
        style: style,
        autofocus: autofocus,
        focusNode: focusNode,
        child: child,
      ),
      AppButtonVariant.secondary => FilledButton.tonal(
        onPressed: onPressed,
        style: style,
        autofocus: autofocus,
        focusNode: focusNode,
        child: child,
      ),
      AppButtonVariant.outline => OutlinedButton(
        onPressed: onPressed,
        style: style,
        autofocus: autofocus,
        focusNode: focusNode,
        child: child,
      ),
    };
  }
}
