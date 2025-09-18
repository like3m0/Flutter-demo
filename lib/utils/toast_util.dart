import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ToastUtil {
  static toast(final String text, {ToastGravity gravity = ToastGravity.CENTER}) {
    Fluttertoast.showToast(
      msg: text,
      toastLength: Toast.LENGTH_SHORT,
      gravity: gravity,
//      timeInSecForIos: 1,
      backgroundColor: Color(0xff9E9E9E),
      textColor: Color(0xffffffff),
    );
  }
}
