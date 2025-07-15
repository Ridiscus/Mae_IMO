import 'package:flutter/material.dart';
import '../../constants/app_size.dart';
import '../../constants/app_colors.dart';
class AppOutlinedBtnTheme {
  static OutlinedButtonThemeData light = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      iconColor: AppColors.primary,
      splashFactory: NoSplash.splashFactory,
      overlayColor: AppColors.primary,
      backgroundColor: AppColors.secondaryLight,
      // textStyle: GoogleFonts.sourceSans3(fontSize: 17, fontWeight: FontWeight.w700),
      foregroundColor: AppColors.primaryTextLight,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(AppSize.radius.md),
        ),
      ),
      side: BorderSide.none,
    ),
  );
  static OutlinedButtonThemeData dark = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: Colors.white,
      side: const BorderSide(color: Colors.white),
    ),
  );
}
