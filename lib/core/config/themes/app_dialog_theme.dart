import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';

class AppDialogTheme {
  static DialogThemeData light = DialogThemeData(
    alignment: Alignment.center,
    backgroundColor: Colors.white,
    titleTextStyle: TextStyle(
      color: AppColors.primary,
      fontSize: 19,
      fontWeight: FontWeight.w700,
    ),
  );
}
