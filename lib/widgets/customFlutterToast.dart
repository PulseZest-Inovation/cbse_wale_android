import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ToastUtil {
  static void showToast({
    required String message,
    Toast length = Toast.LENGTH_SHORT,
    Color? backgroundColor = Colors.orange,
    Color? textColor = Colors.white,
    double? fontSize = 16.0,
    ToastGravity gravity = ToastGravity.CENTER,
  }) =>
      Fluttertoast.showToast(
        msg: message,
        toastLength: length,
        backgroundColor: backgroundColor,
        textColor: textColor,
        fontSize: fontSize,
        gravity: gravity,
      );
}
