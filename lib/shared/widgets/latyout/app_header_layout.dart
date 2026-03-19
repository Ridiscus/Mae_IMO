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

  /// Optional fixed height for the header.
  final double? height;

  /// Whether to align the illustration to the right.
  final bool alignRight;

  /// Creates an app header layout with customizable content.
  const AppHeaderLayout({
    super.key,
    required this.content,
    this.backgroundColor,
    this.padding,
    this.roundedBottomCorners = true,
    this.bottomRadius,
    this.height,
    this.alignRight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          padding ??
          EdgeInsets.symmetric(horizontal: 16.sp).copyWith(bottom: 24.sp),
      width: double.infinity,
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.primary,
        borderRadius:
            roundedBottomCorners
                ? BorderRadius.only(
                  bottomLeft: Radius.circular(bottomRadius ?? 30.r),
                  bottomRight: Radius.circular(bottomRadius ?? 30.r),
                )
                : null,
      ),
      child: Stack(
        children: [
          IllustrationHeader(
            color: Colors.white,
            primaryAlpha: 0.1,
            secondaryAlpha: 0.05,
            alignRight: alignRight,
          ),
          SafeArea(child: content),
        ],
      ),
    );
  }
}
