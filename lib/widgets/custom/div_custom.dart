import 'package:flutter/material.dart';
import 'package:xiangyue/utils/screen_util.dart';

double _position(String? point) {
  switch (point) {
    case 'center':
      return 0.0;
    case 'top':
    case 'left':
      return -1.0;
    case 'bottom':
    case 'right':
      return 1.0;
    default:
      return 0.0;
  }
}

class DivCustom extends StatelessWidget {
  static const String gradientDefault = 'default';

  const DivCustom({
    super.key,
    this.width,
    this.height,
    this.child,
    this.color,
    this.padding,
    this.margin,
    this.border,
    this.borderColor = '#ff333333',
    this.radius,
    this.x = "0",
    this.y = "0",
    this.gradient,
    this.bgImg,
    this.boxShadow,
    this.scale = 1.0,
  });

  final double? width;
  final double? height;
  final Widget? child;

  /// 颜色 hex 字符串（如 "#ff000000"）
  final String? color;

  /// border 支持 List<num> 或 num
  final Object? border;

  /// 圆角支持 List<num> 或 num
  final Object? radius;

  /// border 颜色 hex 字符串
  final String borderColor;

  /// padding 支持 List<num> 或 num 或 EdgeInsets
  final Object? padding;

  /// margin 支持 List<num> 或 num 或 EdgeInsets
  final Object? margin;

  /// alignment x, y
  final String? x;
  final String? y;

  /// 渐变
  final Gradient? gradient;

  /// 背景图
  final DecorationImage? bgImg;

  /// 阴影
  final List<BoxShadow>? boxShadow;

  /// 缩放
  final double scale;

  @override
  Widget build(BuildContext context) {
    int? colorInt = color != null ? int.tryParse(color!.replaceAll('#', '0x')) : null;
    int? borderColorInt = int.tryParse(borderColor.replaceAll('#', '0x'));

    List<double> borderWidth = List.filled(4, 0.0);
    List<double> radiusList = List.filled(4, 0.0);
    List<double> marginList = List.filled(4, 0.0);
    List<double> paddingList = List.filled(4, 0.0);

    if (border is List) {
      final list = border as List;
      for (var i = 0; i < list.length && i < 4; i++) {
        borderWidth[i] = (list[i] as num).toDouble();
      }
    } else if (border is num) {
      for (var i = 0; i < 4; i++) {
        borderWidth[i] = (border as num).toDouble();
      }
    }

    if (radius is List) {
      final list = radius as List;
      for (var i = 0; i < list.length && i < 4; i++) {
        radiusList[i] = (list[i] as num).toDouble();
      }
    } else if (radius is num) {
      for (var i = 0; i < 4; i++) {
        radiusList[i] = (radius as num).toDouble();
      }
    }

    if (margin is List) {
      final list = margin as List;
      for (var i = 0; i < list.length && i < 4; i++) {
        marginList[i] = (list[i] as num).toDouble();
      }
    } else if (margin is num) {
      for (var i = 0; i < 4; i++) {
        marginList[i] = (margin as num).toDouble();
      }
    }

    if (padding is List) {
      final list = padding as List;
      for (var i = 0; i < list.length && i < 4; i++) {
        paddingList[i] = (list[i] as num).toDouble();
      }
    } else if (padding is num) {
      for (var i = 0; i < 4; i++) {
        paddingList[i] = (padding as num).toDouble();
      }
    }

    return Container(
      width: width != null ? getSizeWithScale(width!, scale) : null,
      height: height != null ? getSizeWithScale(height!, scale) : null,
      alignment: (x == null && y == null)
          ? null
          : Alignment(_position(x), _position(y)),
      margin: margin is EdgeInsetsGeometry
          ? margin as EdgeInsetsGeometry
          : EdgeInsets.only(
        top: getSizeWithScale(marginList[0], scale).floorToDouble(),
        right: getSizeWithScale(marginList[1], scale).floorToDouble(),
        bottom: getSizeWithScale(marginList[2], scale).floorToDouble(),
        left: getSizeWithScale(marginList[3], scale).floorToDouble(),
      ),
      padding: padding is EdgeInsetsGeometry
          ? padding as EdgeInsetsGeometry
          : EdgeInsets.only(
        top: getSizeWithScale(paddingList[0], scale).floorToDouble(),
        right: getSizeWithScale(paddingList[1], scale).floorToDouble(),
        bottom: getSizeWithScale(paddingList[2], scale).floorToDouble(),
        left: getSizeWithScale(paddingList[3], scale).floorToDouble(),
      ),
      decoration: BoxDecoration(
        boxShadow: boxShadow,
        image: bgImg,
        color: colorInt != null ? Color(colorInt) : null,
        gradient: gradient,
        border: border == null
            ? null
            : Border(
          top: borderWidth[0] == 0
              ? BorderSide.none
              : BorderSide(
            color: Color(borderColorInt ?? 0x00000000),
            width: getSizeWithScale(borderWidth[0], scale),
          ),
          right: borderWidth[1] == 0
              ? BorderSide.none
              : BorderSide(
            color: Color(borderColorInt ?? 0x00000000),
            width: getSizeWithScale(borderWidth[1], scale),
          ),
          bottom: borderWidth[2] == 0
              ? BorderSide.none
              : BorderSide(
            color: Color(borderColorInt ?? 0x00000000),
            width: getSizeWithScale(borderWidth[2], scale),
          ),
          left: borderWidth[3] == 0
              ? BorderSide.none
              : BorderSide(
            color: Color(borderColorInt ?? 0x00000000),
            width: getSizeWithScale(borderWidth[3], scale),
          ),
        ),
        borderRadius: radius == null
            ? null
            : BorderRadius.only(
          topLeft: Radius.circular(getSizeWithScale(radiusList[0], scale)),
          topRight: Radius.circular(getSizeWithScale(radiusList[1], scale)),
          bottomRight: Radius.circular(getSizeWithScale(radiusList[2], scale)),
          bottomLeft: Radius.circular(getSizeWithScale(radiusList[3], scale)),
        ),
      ),
      child: child,
    );
  }
}
