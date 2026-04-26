import 'package:flutter/widgets.dart';

abstract final class AppShadow {
  static const List<BoxShadow> sm = [
    BoxShadow(
      color: Color(0x0A000000),
      blurRadius: 2,
      offset: Offset(0, 1),
    ),
  ];

  static const List<BoxShadow> md = [
    BoxShadow(
      color: Color(0x14000000),
      blurRadius: 12,
      offset: Offset(0, 4),
    ),
  ];

  static const List<BoxShadow> lg = [
    BoxShadow(
      color: Color(0x1F000000),
      blurRadius: 24,
      offset: Offset(0, 12),
    ),
  ];
}
