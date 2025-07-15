import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/constants/app_colors.dart';

/// Enum to define button color variants
enum ButtonVariant {
  primary,
  red,
  orange,
}

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    this.onPressed,
    required this.text,
    this.isDisabled = false,
    this.width,
    this.height,
    this.color,
    this.isLoading = false,
    this.textStyle,
    this.showArrow = false,
    this.iconSize,
    this.buttonPadding,
    this.buttonVariant = ButtonVariant.primary,
  });

  final void Function()? onPressed;
  final String text;
  final bool isDisabled;
  final double? width;
  final double? height;
  final Color? color;
  final TextStyle? textStyle;
  final bool isLoading;
  final bool showArrow;
  final double? iconSize;
  final EdgeInsetsGeometry? buttonPadding;
  final ButtonVariant buttonVariant;

  /// Get the button color based on the variant
  Color _getButtonColor() {
    if (color != null) return color!;
    
    switch (buttonVariant) {
      case ButtonVariant.primary:
        return AppColors.primary;
      case ButtonVariant.red:
        return AppColors.redColor;
      case ButtonVariant.orange:
        return AppColors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    final buttonColor = _getButtonColor();
    
    return Row(
      children: [
        Flexible(
          child: Container(
            alignment: Alignment.center,
            child: ElevatedButton(
              onPressed: isDisabled || isLoading ? null : onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonColor,
                disabledBackgroundColor: Color.fromRGBO(239, 230, 235, 1),
                padding: buttonPadding ?? EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50.r),
                ),
                minimumSize: Size(width ?? double.infinity, height ?? 56.h),
              ),
              child: isLoading
                  ? CircularProgressIndicator(
                      color: Colors.white,
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            text,
                            textAlign: TextAlign.center,
                            style: textStyle ??
                                TextStyle(
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                          ),
                        ),
                        if (showArrow) ...[
                          SizedBox(width: 16.w),
                          Container(
                            width: iconSize ?? 40.w,
                            height: iconSize ?? 40.w,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Icon(
                                Icons.arrow_forward,
                                color: buttonColor,
                                size: (iconSize ?? 40.w) * 0.6,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
            ),
          ),
        ),
      ],
    );
  }
}
