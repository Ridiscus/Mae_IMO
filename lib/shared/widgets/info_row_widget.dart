part of 'index.dart';

class InfoRowWidget extends StatelessWidget {
  final IconData icon;
  final String text;

  final Color? textColor;
  final FontWeight? fontWeight;

  const InfoRowWidget({
    super.key,
    required this.icon,
    required this.text,
    this.textColor,
    this.fontWeight,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 24.sp, color: textColor ?? Colors.black87),
        SizedBox(width: 16.sp),
        Text(
          text,
          style:
              TextStyle(
                fontSize: 16.sp,
                color: textColor ?? Colors.black87,
                fontWeight: fontWeight ?? FontWeight.normal,
              ).sourceSansProRegular,
        ),
      ],
    );
  }
}
