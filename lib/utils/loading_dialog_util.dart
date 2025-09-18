import 'package:flutter/material.dart';

class LoadingDialogUtil {
  static void show(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (_) => Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  static void hide(BuildContext context) {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  }

  static Widget loadingWidget() {
    return Center(
      child: Container(
        constraints: BoxConstraints.expand(),
        color: Color(0x80000000),
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
