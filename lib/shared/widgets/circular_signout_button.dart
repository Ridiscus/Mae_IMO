part of 'index.dart';

/// A circular button with sign out icon used for logout functionality
class CircularSignOutButton extends StatelessWidget {
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

  /// Creates a circular sign out button
  const CircularSignOutButton({
    super.key,
    this.backgroundColor = Colors.white,
    this.iconColor = Colors.white,
    this.iconSize,
    this.backgroundOpacity = 0.2,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      style: ButtonStyle(
        padding: WidgetStatePropertyAll(EdgeInsets.zero),
        backgroundColor: WidgetStatePropertyAll(
          backgroundColor?.withValues(alpha: backgroundOpacity),
        ),
      ),
      icon: Icon(Icons.logout, color: iconColor, size: iconSize ?? 22.sp),
      onPressed: onPressed ?? () => context.goNamed(PortalPage.routeName),
    );
  }
}
