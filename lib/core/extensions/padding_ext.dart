import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

extension PaddingExt on Widget {
  Widget padding(EdgeInsetsGeometry? padding) => Padding(
    padding: padding ?? EdgeInsets.symmetric(horizontal: 16.w),
    child: this,
  );
}
