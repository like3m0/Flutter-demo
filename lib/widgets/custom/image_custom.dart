// ignore: import_of_legacy_library_into_null_safe
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:xiangyue/utils/screen_util.dart';
import 'package:xiangyue/widgets/custom/text_custom.dart';

import 'div_custom.dart';

class ImageCustom extends StatelessWidget {
  const ImageCustom(
      {Key key,
      this.name,
      this.url = '',
      this.width,
      this.height,
      this.imgType = "png",
      this.text = "",
      this.background = '#00ffffff',
      this.padding,
      this.margin,
      this.x = "0",
      this.y = "0",
      this.border,
      this.borderColor = '#ff333333',
      this.radius,
      this.repeat = ImageRepeat.noRepeat,
      this.alignment = Alignment.center,
      this.placeholder,
      this.boxFit = BoxFit.fill,
      this.scale = 0.7})
      : super(key: key);
  final String name;
  final String url;
  final String text;
  final padding;
  final margin;
  final double width;
  final double height;
  final String imgType;
  final border;
  final radius;
  final String borderColor;
  final String x;
  final String y;
  final String background;
  final BoxFit boxFit;
  final ImageRepeat repeat;
  final Alignment alignment;
  final Widget placeholder;
  final double scale;

  @override
  Widget build(BuildContext context) {
    return DivCustom(
      scale: scale,
      margin: margin,
      padding: padding,
      color: background,
      border: border,
      radius: radius,
      borderColor: borderColor,
      x: x,
      y: y,
      child: name != null
          ? Image.asset(
              "images/${name}.${imgType}",
              fit: boxFit,
              repeat: repeat,
              alignment: alignment,
              width: width == null ? null : getSizeWithScale(width, scale),
              height: height == null ? null : getSizeWithScale(height, scale),
              gaplessPlayback: true,
            )
          : CachedNetworkImage(
              imageUrl: url.startsWith('http') ? url : 'http' + url,
              width: width == null ? null : getSizeWithScale(width, scale),
              height: height == null ? null : getSizeWithScale(height, scale),
              fit: boxFit,
              repeat: repeat,
              alignment: alignment,
              fadeInDuration: placeholder == null
                  ? Duration(seconds: 0)
                  : Duration(milliseconds: 500),
              placeholder: placeholder == null
                  ? null
                  : (BuildContext context, String url) {
                      return placeholder;
                    },
            ),
    );
  }

  static Widget getAnimatedPlaceholder(double width, double height,
      {String color}) {
    return DivCustom(
      radius: 16,
      color: color ?? "#FFFFEDED",
      width: width,
      height: height,
      child: AnimatedPlaceholder(),
    );
  }

  static Widget getPlaceholder(String title, int width, int height) {
    return DivCustom(
      height: height,
      width: width,
      x: '',
      color: '#FFE0E6FF',
      child: TextCustom(
        scale: 0.6,
        text: title,
        textAlign: TextAlign.center,
        size: 28,
        color: '#FFA8B8FD',
      ),
    );
  }
}

class AnimatedPlaceholder extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AnimatedPlaceholderState();
  }
}

class _AnimatedPlaceholderState extends State<AnimatedPlaceholder>
    with TickerProviderStateMixin {
  Animation<double> _animation;
  AnimationController _controller;
  List<String> _assetList = [];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    for (var i = 0; i <= 39; i++) {
      if (i < 10) {
        _assetList.add("images/image_placeholder0$i.png");
      } else {
        _assetList.add("images/image_placeholder$i.png");
      }
    }

    _controller = new AnimationController(
        duration: Duration(milliseconds: 1500), vsync: this);
    _controller.addStatusListener((AnimationStatus status) {
      if (status == AnimationStatus.completed) {
        _controller.reset();
      } else if (status == AnimationStatus.dismissed) {
        _controller.forward();
      }
    });
    _animation =
        new Tween<double>(begin: 0, end: _assetList.length - 1.toDouble())
            .animate(_controller)
              ..addListener(() {
                setState(() {});
              });
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Image.asset(
          _assetList[_animation.value.floor()],
          gaplessPlayback: true,
          width: getSize(150),
          height: getSize(45),
        )
      ],
    );
  }
}
