part of 'index.dart';

/// A circular back button with customizable properties.
///
/// This button is designed with a circular background and a back icon.
/// By default, it navigates back when pressed.
class CircularBackButton extends StatelessWidget {
  /// The background color of the button.
  final Color? backgroundColor;

  /// The icon color.
  final Color? iconColor;

  /// The size of the icon.
  final double? iconSize;

  /// The opacity of the background.
  final double backgroundOpacity;

  /// The action to execute when the button is pressed.
  /// If null, it will default to Navigator.pop.
  final VoidCallback? onPressed;

  /// Creates a circular back button.
  const CircularBackButton({
    super.key,
    this.backgroundColor = Colors.white,
    this.iconColor = Colors.white,
    this.iconSize,
    this.backgroundOpacity = 0.2,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor?.withValues(alpha: backgroundOpacity),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(
          Icons.chevron_left,
          color: iconColor,
          size: iconSize ?? 30.r,
        ),
        onPressed: onPressed ?? () => Navigator.of(context).pop(),
      ),
    );
  }
}
