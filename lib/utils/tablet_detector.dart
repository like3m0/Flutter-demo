import 'package:flutter/widgets.dart';

class TabletDetector {
  static bool isTablet(MediaQueryData query) {
    final data = MediaQueryData.fromWindow(WidgetsBinding.instance.window);
    var isTablet = !(data.size.shortestSide < 600);
    return isTablet;
  }
}
