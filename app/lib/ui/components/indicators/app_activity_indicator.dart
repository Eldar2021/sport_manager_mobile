import 'package:flutter/cupertino.dart';

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
    return Padding(
      padding: padding,
      child: SizedBox(
        height: height,
        width: width,
        child: Center(
          child: CupertinoActivityIndicator(color: color),
        ),
      ),
    );
  }
}
