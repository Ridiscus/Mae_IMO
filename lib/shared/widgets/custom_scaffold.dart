import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomScaffold extends StatelessWidget {
  const CustomScaffold({
    super.key,
    required this.child,
    this.padding,
    this.appBar,
    this.isSafeArea = true,
    this.backgroundColor,
    this.drawer,
    this.extendBodyBehindAppBar = false,
  });

  final Widget child;
  final EdgeInsets? padding;
  final AppBar? appBar;
  final bool isSafeArea;
  final Color? backgroundColor;
  final Drawer? drawer;
  final bool extendBodyBehindAppBar;

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: extendBodyBehindAppBar,
      appBar: appBar,
      backgroundColor: backgroundColor,
      drawer: drawer,
      body: isSafeArea
          ? SafeArea(
              child: Padding(
                padding: padding ?? EdgeInsets.symmetric(horizontal: 14.w),
                child: child,
              ),
            )
          : Padding(
              padding: padding ?? EdgeInsets.symmetric(horizontal: 14.w),
              child: child,
            ),
    );  
  }
}