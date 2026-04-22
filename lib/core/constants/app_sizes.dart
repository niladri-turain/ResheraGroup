import 'package:flutter/material.dart';

class AppSize {
  static late MediaQueryData _mediaQuery;
  static late double screenWidth;
  static late double screenHeight;

  /// Initialize this in main screen (once)
  static void init(BuildContext context) {
    _mediaQuery = MediaQuery.of(context);
    screenWidth = _mediaQuery.size.width;
    screenHeight = _mediaQuery.size.height;
  }

  /// Height based on screen
  static double height(double value) {
    return screenHeight * value;
  }

  /// Width based on screen
  static double width(double value) {
    return screenWidth * value;
  }
}