import 'package:flutter/material.dart' show Color, Colors;

class AppColors {
  // static Color get scaffold => Color.fromRGBO(239, 239, 239, 1);
  static Color get scaffold => Color.fromRGBO(245, 245, 245, 1);

  //-------------------------------------------------
  //Light colors
  static Color get backgroundLight => Colors.white; // Colors.white;

  static Color get primary => const Color.fromRGBO(2, 36, 91, 1);

  static Color get orange => Color.fromRGBO(242, 138, 21, 1);

  static Color get redColor => Color.fromRGBO(132, 32, 41, 1);

  static Color get success => Color.fromRGBO(4, 139, 19, 1);

  static Color get black => Color.fromRGBO(33, 33, 33, 1);
  static Color get fillColor => Color(0xFFEDEDED);


  // 100% = FF
  // 75% = BF
  // 50% = 80
  // 25% = 40
  // 0% = 00

  static Color get fieldBackground => Color.fromRGBO(239, 239, 239, 1);

  static Color get primaryTextLight => black;

  static Color get secondaryTextLight => Color.fromRGBO(0, 0, 0, 0.07);

  static Color get secondaryLight => secondaryTextLight;

  static Color get cardColorLight => Color(0xFFF5F5F5);

  static Color get borderColor => Color.fromRGBO(0, 0, 0, .12);
}
