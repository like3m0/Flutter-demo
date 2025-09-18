import 'dart:io';

// ignore: import_of_legacy_library_into_null_safe
import 'package:flustars/flustars.dart';
import 'package:xiangyue/utils/tablet_detector.dart';

getSize(double size) {
  return ScreenUtil.getInstance().getAdapterSize(size);
}

getSizeWithScale(double size, double scale) {
  return ScreenUtil.getInstance().getAdapterSize(size) *
      (TabletDetector.isTablet(ScreenUtil.getInstance().mediaQueryData)
          ? scale
          : 1);
}

isTablet() {
  return TabletDetector.isTablet(ScreenUtil.getInstance().mediaQueryData);
}

setDefaultDeviceOrientation() {
  // SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  // OrientationPlugin.forceOrientation(DeviceOrientation.portraitUp);

  // if (Platform.isIOS) {
  //   const methodChannel = const MethodChannel('minutescience_flutter');
  //   methodChannel.invokeMethod('setOrientation', "V");
  // } else {
  //   SystemChrome.setPreferredOrientations([
  //     DeviceOrientation.portraitUp,
  //   ]);
  // }
}

setLandscapeDeviceOrientation() {
  // if (Platform.isIOS) {
  //   const methodChannel = const MethodChannel('minutescience_flutter');
  //   methodChannel.invokeMethod('setOrientation', "H");
  // } else {
  //   SystemChrome.setPreferredOrientations([
  //     DeviceOrientation.landscapeLeft,
  //   ]);
  // }

  // if (ScreenUtil.getInstance().mediaQueryData.orientation == Orientation.portrait) {
  //   OrientationPlugin.forceOrientation(Platform.isIOS ?
  //                                         DeviceOrientation.landscapeRight :
  //                                         DeviceOrientation.landscapeLeft);
  // }
  // SystemChrome.setPreferredOrientations([ DeviceOrientation.landscapeLeft,
  //                                           DeviceOrientation.landscapeRight]);
}
