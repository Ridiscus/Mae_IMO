import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_size.dart';
import 'app_bar_theme.dart';
import 'app_btn_theme.dart';
import 'app_date_picker_theme.dart';
import 'app_dialog_theme.dart';
import 'app_outlined_btn_theme.dart';
import 'app_text_btn.dart';
import 'app_text_theme.dart';
import 'app_textfield_theme.dart';

class AppTheme {
  static final ThemeData light = ThemeData(
    fontFamily: 'Inter',
    colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
    useMaterial3: true,
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStatePropertyAll(Colors.white),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(AppSize.radius.md)),
      ),
    ),
    primaryColorLight: AppColors.primary,
    cardColor: AppColors.cardColorLight,
    // primaryTextTheme: GoogleFonts.sourceSans3TextTheme(),
    progressIndicatorTheme: ProgressIndicatorThemeData(
      circularTrackColor: AppColors.primary,
      refreshBackgroundColor: Colors.white,
      color: Colors.white,
      strokeCap: StrokeCap.round,
    ),
    brightness: Brightness.light,
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.backgroundLight,
    inputDecorationTheme: AppTextfieldTheme.light,
    textTheme: AppTextTheme.light,
    textSelectionTheme: TextSelectionThemeData(cursorColor: AppColors.primary),
    datePickerTheme: AppDatePickerTheme.light,
    outlinedButtonTheme: AppOutlinedBtnTheme.light,
    elevatedButtonTheme: AppBtnTheme.light,
    textButtonTheme: AppTextBtn.light,
    appBarTheme: AppBarThemeCustom.light,
    dialogTheme: AppDialogTheme.light,
  );
}
