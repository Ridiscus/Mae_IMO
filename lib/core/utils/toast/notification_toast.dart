
import 'package:maelys_imo/core/utils/toast/toastification_type_wrapper.dart';
import "package:flutter/material.dart"
    show
    Alignment,
    BorderRadius,
    BoxDecoration,
    BoxShadow,
    BuildContext,
    CircleAvatar,
    Color,
    Colors,
    Container,
    EdgeInsets,
    Expanded,
    FontWeight,
    GestureDetector,
    Icon,
    MediaQuery,
    Offset,
    Row,
    SizedBox,
    Text,
    TextOverflow,
    TextStyle,
    VoidCallback;
import 'package:flutter_screenutil/flutter_screenutil.dart' show SizeExtension;
import 'package:toastification/toastification.dart'
    show
    ToastificationCallbacks,
    ToastificationItem,
    ToastificationType,
    toastification;


void clearToast() {
  toastification.dismissAll();
}

void clearToastBy({String? id, ToastificationItem? instance}) {
  if (id?.isNotEmpty ?? false) {
    toastification.dismissById(id!);
  } else {
    if (instance != null) toastification.dismiss(instance);
  }
}

void showToast({
  required String msg,
  int autoCloseDuration = 3,
  ToastificationType type = ToastificationType.error,
  Alignment alignment = Alignment.topCenter,
  ToastificationCallbacks callbacks = const ToastificationCallbacks(),
  BuildContext? context,
  String? textAction,
  VoidCallback? onTapAction,
}) {
  toastification.showCustom(
    autoCloseDuration: Duration(seconds: 3),
    alignment: alignment,
    context: context,
    builder: (BuildContext context, ToastificationItem holder) {
      return GestureDetector(
        onTap: () {
          clearToastBy(instance: holder);
        },
        child: Container(
          padding: EdgeInsets.all(8),
          margin: EdgeInsets.symmetric(horizontal: 20.sp).copyWith(bottom: 10),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 15,
                offset: const Offset(0, 3), // changes position of shadow
              ),
            ],
            // color: Colors.white,
            color: Color.fromRGBO(255, 255, 255, 1),
            borderRadius: BorderRadius.circular(
              MediaQuery.of(context).size.width,
            ),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: ToastificationManager()
                    .getColor(type)
                    .withValues(alpha: .2), // Color.fromRGBO(255, 196, 196, 1),
                child: Icon(
                  ToastificationManager().getIcon(type),
                  color: ToastificationManager().getColor(type),
                  weight: 50,
                  size: 24,
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  msg,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              if ((textAction?.isNotEmpty ?? false) && onTapAction != null) ...[
                SizedBox(width: 10),
                GestureDetector(
                  onTap: onTapAction,
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(255, 211, 174, 1),
                      borderRadius: BorderRadius.circular(
                        MediaQuery.of(context).size.width,
                      ),
                    ),
                    child: Text(
                      "$textAction",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      );
    },
  );
}
