part of 'index.dart';

/// A customizable spacer widget that provides spacing.
///
/// By default, it creates a vertical space of 16.h, but the space
/// can be customized through the constructor and can be either vertical or horizontal.
class CustomSpacer extends StatelessWidget {
  /// The amount of space. Defaults to 1 unit (16.h or 16.w)
  final double space;
  
  /// Controls whether the spacer creates vertical (true) or horizontal (false) space.
  /// Defaults to true (vertical).
  final bool? isVertical;

  /// Creates a [CustomSpacer] with optional custom space amount and direction.
  ///
  /// If [space] is not provided, it defaults to 1 unit (16.h or 16.w).
  /// If [isVertical] is not provided or is true, it creates vertical space.
  /// If [isVertical] is false, it creates horizontal space.
  const CustomSpacer({super.key, this.space = 1, this.isVertical});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: (isVertical ?? true) ? (space * 16).h : null,
      width: (isVertical ?? true) ? null : (space * 16).w,
    );
  }
}
