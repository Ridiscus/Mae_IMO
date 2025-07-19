part of 'index.dart';

class Fonts {
  static TextStyle baseStyle = TextStyle(fontWeight: FontWeight.w400);

  static TextStyle thin = baseStyle.copyWith(fontSize: 12.sp);

  static TextStyle medium = baseStyle.copyWith(fontSize: 16.sp);

  static TextStyle title = baseStyle.copyWith(fontSize: 28.sp);

  static TextStyle labelField = baseStyle.copyWith(fontSize: 14.sp);

  static TextStyle placeholder = baseStyle.copyWith(
    fontSize: 14.sp,
    color: Colors.black,
  );

  static TextStyle button = baseStyle.copyWith(
    fontSize: 20.sp,
    color: Colors.white,
  );

  static TextStyle extra = baseStyle;

  static TextStyle header = baseStyle.copyWith(
    fontSize: 32.sp,
    color: Colors.black,
  );

  static TextStyle smallTitle = baseStyle.copyWith(fontSize: 20.sp);
  static TextStyle body = baseStyle.copyWith(fontSize: 16.sp);

  static TextStyle titleBody = baseStyle.copyWith(
    fontSize: 16.sp,
    color: Color.fromRGBO(106, 106, 106, 1),
  );
  static TextStyle bodySmall = baseStyle.copyWith(
    fontSize: 14.sp,
    color: Colors.black,
  );

  static TextStyle textButton = baseStyle.copyWith(
    fontSize: 17.sp,
    color: AppColors.primary,
  );

  static TextStyle sectionTitle = baseStyle.copyWith(
    fontSize: 22.sp,
    color: Colors.black,
  );
}
