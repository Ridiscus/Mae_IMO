import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';

class AppBtnTheme {
  static final ElevatedButtonThemeData light = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primary,
      minimumSize: Size(double.infinity,59),
      // textStyle: GoogleFonts.sourceSans3(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
      foregroundColor: Colors.white,
      elevation: 0,
      disabledForegroundColor: Colors.white,
      disabledBackgroundColor: AppColors.primary,
      enableFeedback: false,
      splashFactory: NoSplash.splashFactory,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(50),
        ),
      ),
    ),
  );
}
