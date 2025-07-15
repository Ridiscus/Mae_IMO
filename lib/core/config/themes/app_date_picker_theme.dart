import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_size.dart';

class AppDatePickerTheme {
  static DatePickerThemeData light = DatePickerThemeData(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppSize.radius.lg),
    ),
    backgroundColor: AppColors.backgroundLight,
    surfaceTintColor: AppColors.primary,
    headerBackgroundColor: AppColors.primary,
    headerForegroundColor: Colors.white,
    dayStyle: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
    ),
    yearStyle: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
    ),
    weekdayStyle: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.bold,
      color: AppColors.secondaryTextLight,
    ),
    headerHeadlineStyle: TextStyle(
      color: AppColors.secondaryLight,
      fontSize: 18,
      fontWeight: FontWeight.bold,
    ),
    headerHelpStyle: TextStyle(
      color: AppColors.secondaryLight,
      fontSize: 18,
    ),
  );
}
