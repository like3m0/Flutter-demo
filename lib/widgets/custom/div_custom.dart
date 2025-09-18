import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:xiangyue/utils/screen_util.dart';

double position(point) {
  switch (point) {
    case 'center':
      {
        return 0.0;
      }
      break;
    case 'top':
      {
        return -1.0;
      }
      break;
    case 'left':
      {
        return -1.0;
      }
      break;
    case 'bottom':
      {
        return 1.0;
      }
      break;
    case 'right':
      {
        return 1.0;
      }
      break;
    default:
      {
        return 0.0;
      }
      break;
  }
}

class DivCustom extends StatelessWidget {
  static final String gradientDefault = 'default';

  const DivCustom(
      {Key key,
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
      this.scale = 1.0})
      : super(key: key);
  final width;
  final height;
  final Widget child;
  final color;
  final border;
  final radius;
  final String borderColor;
  final padding;
  final margin;
  final String x;
  final String y;
  final gradient;
  final DecorationImage bgImg;
  final boxShadow;
  final double scale;

  @override
  Widget build(BuildContext context) {
    var colorInt =
        color != null ? int.parse(color.replaceAll('#', '0x')) : null;
    var borderColorInt = borderColor != null
        ? int.parse(borderColor.replaceAll('#', '0x'))
        : null;
    List<double> borderWidth = [0, 0, 0, 0];
    List<double> radiusList = [0, 0, 0, 0];
    List<double> marginList = [0, 0, 0, 0];
    List<double> paddingList = [0, 0, 0, 0];
    if (border is List) {
      for (var i = 0; i < border.length; i++) {
        borderWidth[i] = border[i].toDouble();
      }
    } else if (border is num) {
      for (var i = 0; i < 4; i++) {
        borderWidth[i] = border.toDouble();
      }
    }
    if (radius is List) {
      for (var i = 0; i < radius.length; i++) {
        radiusList[i] = radius[i].toDouble();
      }
    } else if (radius is num) {
      for (var i = 0; i < 4; i++) {
        radiusList[i] = radius.toDouble();
      }
    }
    if (margin is List) {
      for (var i = 0; i < margin.length; i++) {
        marginList[i] = margin[i].toDouble();
      }
    } else if (margin is num) {
      for (var i = 0; i < 4; i++) {
        marginList[i] = margin.toDouble();
      }
    }
    if (padding is List) {
      for (var i = 0; i < padding.length; i++) {
        paddingList[i] = padding[i].toDouble();
      }
    } else if (padding is num) {
      for (var i = 0; i < 4; i++) {
        paddingList[i] = padding.toDouble();
      }
    }
    return Container(
      width: width != null ? getSizeWithScale(width.toDouble(), scale) : null,
      height:
          height != null ? getSizeWithScale(height.toDouble(), scale) : null,
      alignment:
          (x == null && y == null) ? null : Alignment(position(x), position(y)),
      margin: margin is EdgeInsetsGeometry
          ? margin
          : EdgeInsets.only(
              top: getSizeWithScale(marginList[0], scale).floor().toDouble(),
              right: getSizeWithScale(marginList[1], scale).floor().toDouble(),
              bottom: getSizeWithScale(marginList[2], scale).floor().toDouble(),
              left: getSizeWithScale(marginList[3], scale).floor().toDouble()),
      padding: padding is EdgeInsetsGeometry
          ? padding
          : EdgeInsets.only(
              top: getSizeWithScale(paddingList[0], scale).floor().toDouble(),
              right: getSizeWithScale(paddingList[1], scale).floor().toDouble(),
              bottom:
                  getSizeWithScale(paddingList[2], scale).floor().toDouble(),
              left: getSizeWithScale(paddingList[3], scale).floor().toDouble()),
      decoration: BoxDecoration(
          boxShadow: boxShadow == null ? null : boxShadow,
          image: bgImg == null ? null : bgImg,
          color: color != null ? Color(colorInt) : null,
          gradient: gradient != null
              ? (gradient == gradientDefault
                  ? const LinearGradient(
                      colors: [Color(0xFFFBCA56), Color(0xFFFFB238)])
                  : gradient)
              : null,
          border: border == null
              ? null
              : Border(
                  top: borderWidth[0] == 0
                      ? BorderSide.none
                      : BorderSide(
                          color: Color(borderColorInt),
                          width: getSizeWithScale(borderWidth[0], scale)),
                  right: borderWidth[1] == 0
                      ? BorderSide.none
                      : BorderSide(
                          color: Color(borderColorInt),
                          width: getSizeWithScale(borderWidth[1], scale)),
                  bottom: borderWidth[2] == 0
                      ? BorderSide.none
                      : BorderSide(
                          color: Color(borderColorInt),
                          width: getSizeWithScale(borderWidth[2], scale)),
                  left: borderWidth[3] == 0
                      ? BorderSide.none
                      : BorderSide(
                          color: Color(borderColorInt),
                          width: getSizeWithScale(borderWidth[3], scale))),
          borderRadius: radius == null
              ? null
              : BorderRadius.only(
                  topLeft:
                      Radius.circular(getSizeWithScale(radiusList[0], scale)),
                  topRight:
                      Radius.circular(getSizeWithScale(radiusList[1], scale)),
                  bottomRight:
                      Radius.circular(getSizeWithScale(radiusList[2], scale)),
                  bottomLeft:
                      Radius.circular(getSizeWithScale(radiusList[3], scale)))),
      child: child,
    );
  }
}
