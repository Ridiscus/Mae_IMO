part of '../../widgets/index.dart';

/// A reusable header component with customizable content.
///
/// This header is used across multiple screens in the application and features
/// a colored background with rounded bottom corners and customizable content.
class AppHeaderLayout extends StatelessWidget {
  /// The background color of the header. Default is AppColors.primary.
  final Color? backgroundColor;

  /// The content to display in the header.
  final Widget content;

  /// Padding to apply to the header content.
  final EdgeInsetsGeometry? padding;

  /// Whether to add rounded corners at the bottom of the header.
  final bool roundedBottomCorners;

  /// The radius of the bottom corners when [roundedBottomCorners] is true.
  final double? bottomRadius;

  /// Creates an app header layout with customizable content.
  const AppHeaderLayout({
    super.key,
    required this.content,
    this.backgroundColor,
    this.padding,
    this.roundedBottomCorners = true,
    this.bottomRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          padding ??
          EdgeInsets.symmetric(horizontal: 16.sp).copyWith(bottom: 16.sp),
      width: double.infinity,
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.primary,
        borderRadius:
            roundedBottomCorners
                ? BorderRadius.only(
                  bottomLeft: Radius.circular(bottomRadius ?? 20.r),
                  bottomRight: Radius.circular(bottomRadius ?? 20.r),
                )
                : null,
      ),
      child: SafeArea(child: content),
    );
  }
}
