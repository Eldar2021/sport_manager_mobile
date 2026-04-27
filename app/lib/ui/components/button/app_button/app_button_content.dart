part of 'app_button.dart';

/// Row of `[leading?] child [trailing?]` used as the expanded button body.
///
/// Icon and text colors are inherited from the surrounding [IconTheme] /
/// [DefaultTextStyle], which the underlying Material button sets from the
/// resolved foreground color — so callers don't need to thread colors through.
class AppButtonContent extends StatelessWidget {
  const AppButtonContent({
    required this.child,
    required this.sizeConfig,
    this.leading,
    this.trailing,
    super.key,
  });

  final Widget child;
  final Widget? leading;
  final Widget? trailing;
  final AppButtonSizeConfig sizeConfig;

  @override
  Widget build(BuildContext context) {
    final iconData = IconThemeData(size: sizeConfig.iconSize);
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (leading != null) ...[
          IconTheme.merge(
            data: iconData,
            child: leading!,
          ),
          SizedBox(width: sizeConfig.iconGap),
        ],
        Flexible(child: child),
        if (trailing != null) ...[
          SizedBox(width: sizeConfig.iconGap),
          IconTheme.merge(
            data: iconData,
            child: trailing!,
          ),
        ],
      ],
    );
  }
}

/// Circular progress indicator sized to a button's [AppButtonSizeConfig].
class AppButtonLoadingIndicator extends StatelessWidget {
  const AppButtonLoadingIndicator({
    required this.size,
    required this.color,
    super.key,
  });

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        valueColor: AlwaysStoppedAnimation<Color>(color),
      ),
    );
  }
}
