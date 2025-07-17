part of 'index.dart';

/// A reusable pagination dot widget that can be either active or inactive.
///
/// The active dot is wider and colored with AppColors.orange,
/// while the inactive dot is narrower and white.
class PaginationDot extends StatelessWidget {
  /// Whether this dot is currently active
  final bool isActive;

  /// Optional horizontal margin for the dot
  final double horizontalMargin;

  /// Optional active width for the dot
  final double activeWidth;

  /// Optional inactive width for the dot
  final double inactiveWidth;

  /// Optional height for the dot
  final double height;

  /// Optional active color for the dot
  final Color? activeColor;

  /// Optional inactive color for the dot
  final Color? inactiveColor;

  /// Optional border radius for the dot
  final double borderRadius;

  PaginationDot({
    Key? key,
    required this.isActive,
    this.horizontalMargin = 2.0,
    this.activeWidth = 20.0,
    this.inactiveWidth = 10.0,
    this.height = 6.0,
    this.activeColor,
    this.inactiveColor,
    this.borderRadius = 4.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: horizontalMargin.sp),
      width: isActive ? activeWidth.w : inactiveWidth.w,
      height: height.h,
      decoration: BoxDecoration(
        color: isActive ? (activeColor ?? AppColors.orange) : (inactiveColor ?? Colors.white),
        borderRadius: BorderRadius.circular(borderRadius.sp),
      ),
    );
  }
}
