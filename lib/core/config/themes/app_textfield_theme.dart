import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_size.dart';

class AppTextfieldTheme {
  static InputDecorationTheme light = InputDecorationTheme(
    filled: true,
    focusColor: Colors.black,
    
    contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 14),
    fillColor: Color.fromRGBO(235, 235, 239, 1),
    hintStyle: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: AppColors.secondaryTextLight,
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.transparent, width: 1),
      borderRadius: BorderRadius.all(Radius.circular(AppSize.radius.md)),
    ),
    errorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: AppColors.redColor, width: 1),
      borderRadius: BorderRadius.all(Radius.circular(AppSize.radius.md)),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: AppColors.redColor, width: 2),
      borderRadius: BorderRadius.all(Radius.circular(AppSize.radius.md)),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.transparent, width: 1),
      borderRadius: BorderRadius.all(Radius.circular(AppSize.radius.md)),
    ),
  );
}
