part of 'index.dart';

/// A customizable spacer widget that provides vertical spacing.
///
/// By default, it creates a vertical space of 16.h, but the height
/// can be customized through the constructor.
class CustomSpacer extends StatelessWidget {
  /// The height of the spacer. Defaults to 16.h
  final double space;

  /// Creates a [CustomSpacer] with an optional custom height.
  ///
  /// If [height] is not provided, it defaults to 16.h.
  const CustomSpacer({super.key, this.space = 1});

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: (space * 16).h);
  }
}
