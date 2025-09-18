import 'package:flutter/widgets.dart';

class ThemeSettings extends ChangeNotifier {
  static const arrBgColor = [
    Color(0xFF292D33),
    Color(0xFF0D214D),
    Color(0xFF13491C),
    Color(0xFF661711)
  ]; //四种背景色
  static const arrBgColorString = [
    "0xFF292D33",
    "0xFF0D214D",
    "0xFF13491C",
    "0xFF661711"
  ];
  static const arrBgImage = [
    "bg_lasi",
    "bg_lasi_blue",
    "bg_lasi_green",
    "bg_lasi_red"
  ];
  //背景设置 0黑色 1蓝色 2绿色 3红色
  int themeIndex = 0;
  void setSettingIndex(int index) {
    this.themeIndex = index;
    notifyListeners();
  }

  Color getBackgroundColor() {
    return ThemeSettings.arrBgColor[this.themeIndex];
  }

  String getBackgroundColorString() {
    return ThemeSettings.arrBgColorString[this.themeIndex];
  }

  String getBackgroundImageName() {
    return ThemeSettings.arrBgImage[this.themeIndex];
  }
}
