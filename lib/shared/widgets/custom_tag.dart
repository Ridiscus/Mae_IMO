part of 'index.dart';

/// A customizable tag widget that displays text with a colored background.
///
/// The tag has rounded corners and can be customized with different colors and text.
class CustomTag extends StatelessWidget {
  /// The label text to display in the tag.
  final String label;

  /// The background color of the tag. 
  final Color color;

  /// Optional padding for the tag. Defaults to horizontal padding of 8.sp.
  final EdgeInsetsGeometry? padding;

  /// Optional text style for the label. If not provided, defaults to white text with 12.r font size.
  final TextStyle? textStyle;

  /// Creates a [CustomTag] with the specified label and color.
  ///
  /// The [label] parameter is required and represents the text to be displayed in the tag.
  /// The [color] parameter is required and sets the background color of the tag.
  /// The [padding] parameter is optional and defaults to horizontal padding of 8.sp.
  /// The [textStyle] parameter is optional and defaults to white text with 12.r font size.
  const CustomTag({
    super.key,
    required this.label,
    required this.color,
    this.padding,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? EdgeInsets.symmetric(horizontal: 8.sp),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Text(
        label,
        style: textStyle ?? 
            TextStyle(
              fontSize: 12.r,
              color: Colors.white,
            ).sourceSansProSemiBold,
      ),
    );
  }
}
