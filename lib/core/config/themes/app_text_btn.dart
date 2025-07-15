import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';

class AppTextBtn {
  static TextButtonThemeData light = TextButtonThemeData(
    style: TextButton.styleFrom(
        foregroundColor: AppColors.primary,
        splashFactory: NoSplash.splashFactory,
        // textStyle: GoogleFonts.sourceSans3(
        //   color: AppColors.primary,
        //   fontSize: 16,
        //   fontWeight: FontWeight.w800,
        //
        // )
    ),
  );
}
