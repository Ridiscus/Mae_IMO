import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_size.dart';

class AppSearchBarTheme {
  static SearchBarThemeData light = SearchBarThemeData(
      // textStyle: WidgetStatePropertyAll(
      //   GoogleFonts.sourceSans3(
      //     fontSize: 16,
      //     fontWeight: FontWeight.w600,
      //     color: AppColors.primary,
      //   ),
      // ),
      // hintStyle: WidgetStatePropertyAll(
      //   GoogleFonts.sourceSans3(
      //     fontSize: 16,
      //     fontWeight: FontWeight.w400,
      //     color: AppColors.primary,
      //   ),
      // ),
      elevation: const WidgetStatePropertyAll(0),
      backgroundColor: WidgetStatePropertyAll(AppColors.secondaryLight),
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSize.radius.md),
        ),
      ));
}
