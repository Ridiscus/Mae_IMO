import 'package:flutter/material.dart' show BuildContext, MaterialPageRoute;
import 'package:flutter/widgets.dart';

extension NavigatorExt on BuildContext {
  dynamic navigateTo(Widget page) =>
      Navigator.push(this, MaterialPageRoute(builder: (context) => page));

  dynamic navigateAndReplace(Widget page) => Navigator.pushReplacement(
    this,
    MaterialPageRoute(builder: (context) => page),
  );

  dynamic navigateAndRemoveUntil(Widget page) => Navigator.pushAndRemoveUntil(
    this,
    MaterialPageRoute(builder: (context) => page),
    (route) => false,
  );

  dynamic navigateBack({dynamic result}) => Navigator.pop(this, result);
}
