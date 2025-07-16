part of 'index.dart';

extension PaddingExt on Widget {
  Widget padding(EdgeInsetsGeometry? padding) => Padding(
    padding: padding ?? EdgeInsets.symmetric(horizontal: 16.w),
    child: this,
  );
}
