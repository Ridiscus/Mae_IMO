import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';

class AppBarThemeCustom {
  static AppBarTheme light = AppBarTheme(
    backgroundColor: AppColors.backgroundLight,
    elevation: 0,
    centerTitle: true,
    iconTheme: IconThemeData(
      color: Colors.black,
    ),
    titleTextStyle: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: AppColors.primaryTextLight),
    surfaceTintColor: Colors.white,
    foregroundColor: AppColors.primaryTextLight,
  );
}


