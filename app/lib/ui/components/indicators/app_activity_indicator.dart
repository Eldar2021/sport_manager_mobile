import 'package:flutter/cupertino.dart';

/// App-wide activity indicator. Uses [CupertinoActivityIndicator] on every
/// platform for visual consistency — we deliberately don't fall back to the
/// Material spinner on Android.
class AppActivityIndicator extends StatelessWidget {
  const AppActivityIndicator({
    this.padding = EdgeInsets.zero,
    this.height,
    this.width,
    this.color,
    super.key,
  });

  final double? height;
  final double? width;
  final Color? color;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    Widget indicator = CupertinoActivityIndicator(color: color);
    if (height != null || width != null) {
      indicator = SizedBox(
        height: height,
        width: width,
        child: Center(child: indicator),
      );
    }
    return Padding(padding: padding, child: indicator);
  }
}
