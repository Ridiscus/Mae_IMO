part of 'index.dart';

/// Enum to define button color variants
enum ButtonVariant { primary, red, orange }

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
    this.iconData,
    this.assetPath,
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
  final IconData? iconData;
  final String? assetPath;

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

    return Container(
      alignment: Alignment.center,
      child: ElevatedButton(
        onPressed: isDisabled || isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor,
          disabledBackgroundColor: Color.fromRGBO(239, 230, 235, 1),
          padding:
              buttonPadding ??
              EdgeInsets.symmetric(
                horizontal: 24.w,
                vertical: 10.h,
              ).copyWith(right: 10.w),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
          minimumSize: Size(width ?? double.infinity, 30.h),
        ),
        child:
            isLoading
                ? CircularProgressIndicator(color: Colors.white)
                : Stack(
                  alignment: Alignment.center,
                  children: [
                    Center(
                      child: Text(
                        text,
                        style:
                            TextStyle(
                              fontSize: 19.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ).sourceSansProBold,
                      ),
                    ),
                    if (showArrow)
                      Align(
                        alignment: Alignment.centerRight,
                        child: CircleAvatar(
                          radius: 16.r,
                          backgroundColor: Colors.white,
                          child:
                              assetPath != null
                                  ? SvgPicture.asset(
                                    assetPath!,
                                    width: (iconSize ?? 24.w) * 0.6,
                                    height: (iconSize ?? 24.w) * 0.6,
                                    colorFilter: ColorFilter.mode(
                                      buttonColor,
                                      BlendMode.srcIn,
                                    ),
                                  )
                                  : Icon(
                                    iconData ?? Icons.adaptive.arrow_forward,
                                    color: buttonColor,
                                    size: (iconSize ?? 30.w) * 0.6,
                                  ),
                        ),
                      ),
                  ],
                ),
      ),
    );
  }
}
