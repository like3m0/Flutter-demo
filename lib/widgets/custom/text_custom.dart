// ignore: import_of_legacy_library_into_null_safe
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:xiangyue/utils/screen_util.dart';
import 'package:xiangyue/widgets/custom/div_custom.dart';

class TextCustom extends StatelessWidget {
  const TextCustom(
      {Key? key,
      this.width,
      this.height,
      this.fontFamily,
      this.text = "",
      this.size = 14,
      this.color = '#ffffffff',
      this.background,
      this.lineHeight = 0,
      this.weight = FontWeight.normal,
      this.padding,
      this.margin,
      this.x = "0",
      this.y = "0",
      this.border,
      this.borderColor = '#ff333333',
      this.radius,
      this.gradient,
      this.maxLines,
      this.textAlign = TextAlign.center,
      this.overflow,
      this.boxShadow,
      this.scale = 1.0,
      this.shadow})
      : super(key: key);
  final String text;
  final String color;
  final double lineHeight;
  final FontWeight weight;
  final double size;
  final padding;
  final margin;
  final width;
  final height;
  final border;
  final radius;
  final String borderColor;
  final String x;
  final String y;
  final background;
  final gradient;
  final fontFamily;
  final maxLines;
  final TextAlign textAlign;
  final overflow;
  final boxShadow;
  final double scale;
  final shadow;
  @override
  Widget build(BuildContext context) {
    var colorInt = int.parse(color.replaceAll('#', '0x'));
    return DivCustom(
      scale: scale,
      width: width,
      height: height,
      margin: margin,
      padding: padding,
      color: background,
      border: border,
      radius: radius,
      borderColor: borderColor,
      boxShadow: boxShadow,
      x: x,
      y: y,
      gradient: gradient,
      child: Text(ObjectUtil.isEmpty(text) ? '' : text,
          textAlign: textAlign,
          maxLines: maxLines,
          overflow: overflow,
          style: TextStyle(
            shadows: shadow,
            color: Color(colorInt),
            height: lineHeight,
            decoration: TextDecoration.none,
            fontFamily: fontFamily,
            fontWeight: weight,
            fontSize: getSizeWithScale(size, scale),
          )),
    );
  }
}
