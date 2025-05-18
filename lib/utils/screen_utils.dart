import 'package:flutter/material.dart';

class ScreenUtil {
  static double? screenHeight;
  static double? screenWidth;

  static void init(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    screenHeight = mediaQuery.size.height;
    screenWidth = mediaQuery.size.width;
  }
}
