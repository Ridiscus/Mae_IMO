import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

mixin ToastificationTypeWrapper implements ToastificationType {
  String model = ToastificationType.info.name;

  @override
  String get name => model;

  @override
  Color get color {
    switch (name) {
      case 'error':
        return Color.fromRGBO(255, 196, 196, 1);
      case 'success':
        return Color.fromRGBO(202, 255, 224, 1);
      case 'warning':
        return Color.fromRGBO(255, 217, 180, 1);
      default:
        return infoColor;
    }
  }

  @override
  IconData get icon {
    switch (name) {
      case 'error':
        return Icons.close;
      case 'success':
        return Icons.check;
      case 'warning':
        return Icons.warning_amber_rounded;
      default:
        return Icons.info;
    }
  }

  Color getColor(ToastificationType type) {
    model = type.name;
    return color;
  }

  IconData getIcon(ToastificationType type) {
    model = type.name;
    return icon;
  }
}

class ToastificationManager {
  String name = ToastificationType.info.name;

  Color get color {
    switch (name) {
      case 'error':
        return Color.fromRGBO(255, 0, 0, 1);
        // return Color.fromRGBO(255, 196, 196, 1);
      case 'success':
        return Color.fromRGBO(18, 174, 83, 1);
        // return Color.fromRGBO(202, 255, 224, 1);
      case 'warning':
        return Color.fromRGBO(237, 129, 21, 1);
        // return Color.fromRGBO(255, 217, 180, 1);
      default:
        return infoColor;
    }
  }

  IconData get icon {
    switch (name) {
      case 'error':
        return Icons.close;
      case 'success':
        return Icons.check;
      case 'warning':
        return Icons.warning_amber_rounded;
      default:
        return Icons.info;
    }
  }

  Color getColor(ToastificationType type) {
    name = type.name;
    return color;
  }

  IconData getIcon(ToastificationType type) {
    name = type.name;
    return icon;
  }
}
