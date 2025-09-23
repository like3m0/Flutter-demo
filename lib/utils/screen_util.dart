import 'dart:io';
import 'package:flutter/services.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flustars/flustars.dart';
import 'package:xiangyue/utils/tablet_detector.dart';

/// 按适配尺寸返回（显式返回 double）
double getSize(double size) {
  return ScreenUtil.getInstance().getAdapterSize(size);
}

/// 带“平板缩放”逻辑的适配尺寸（显式返回 double + 空安全）
double getSizeWithScale(double size, double scale) {
  final mq = ScreenUtil.getInstance().mediaQueryData; // 可能为 null（初始化前）
  final bool onTablet = mq != null && TabletDetector.isTablet(mq);
  return ScreenUtil.getInstance().getAdapterSize(size) * (onTablet ? scale : 1.0);
}

/// 是否为平板（显式返回 bool + 空安全）
bool isTablet() {
  final mq = ScreenUtil.getInstance().mediaQueryData;
  return mq != null && TabletDetector.isTablet(mq);
}

/// 竖屏方向（显式返回 Future<void>）
Future<void> setDefaultDeviceOrientation() async {
  // 如需自定义 iOS / Android 不同策略，可在这里按平台区分
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
}

/// 横屏方向（显式返回 Future<void>）
Future<void> setLandscapeDeviceOrientation() async {
  // 常见做法：允许左右横屏
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
}
