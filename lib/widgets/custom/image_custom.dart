// ignore: import_of_legacy_library_into_null_safe
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:xiangyue/utils/screen_util.dart';
import 'package:xiangyue/widgets/custom/text_custom.dart';

import 'div_custom.dart';

class ImageCustom extends StatelessWidget {
  const ImageCustom({
    super.key,
    this.name,
    this.url = '',
    this.width,
    this.height,
    this.imgType = 'png',
    this.text = '',
    this.background = '#00ffffff',
    this.padding,
    this.margin,
    this.x = '0',
    this.y = '0',
    this.border,
    this.borderColor = '#ff333333',
    this.radius,
    this.repeat = ImageRepeat.noRepeat,
    this.alignment = Alignment.center,
    this.placeholder,
    this.boxFit = BoxFit.fill,
    this.scale = 0.7,
  });

  final String? name;
  final String url;
  final String text;

  /// 支持 EdgeInsets / num / List<num>
  final Object? padding;

  /// 支持 EdgeInsets / num / List<num>
  final Object? margin;

  final double? width;
  final double? height;

  final String imgType;

  /// 支持 num / List<num>
  final Object? border;

  /// 支持 num / List<num>
  final Object? radius;

  final String borderColor;
  final String x;
  final String y;
  final String background;

  final BoxFit boxFit;
  final ImageRepeat repeat;
  final Alignment alignment;

  /// 可选：自定义占位 Widget
  final Widget? placeholder;

  /// 尺寸缩放
  final double scale;

  @override
  Widget build(BuildContext context) {
    final double? w = width == null ? null : getSizeWithScale(width!, scale);
    final double? h = height == null ? null : getSizeWithScale(height!, scale);

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
        'images/$name.$imgType',
        fit: boxFit,
        repeat: repeat,
        alignment: alignment,
        width: w,
        height: h,
        gaplessPlayback: true,
      )
          : CachedNetworkImage(
        imageUrl: _normalizeUrl(url),
        width: w,
        height: h,
        fit: boxFit,
        repeat: repeat,
        alignment: alignment,
        fadeInDuration:
        placeholder == null ? const Duration(seconds: 0) : const Duration(milliseconds: 500),
        placeholder: placeholder == null
            ? null
            : (BuildContext _, String __) => placeholder!,
      ),
    );
  }

  String _normalizeUrl(String raw) {
    final u = raw.trim();
    if (u.isEmpty) return '';
    if (u.startsWith('http://') || u.startsWith('https://')) return u;
    // 保留你原来的逻辑，但更稳妥：若无协议，默认补 https
    return 'https://$u';
  }

  static Widget getAnimatedPlaceholder(double width, double height, {String? color}) {
    return DivCustom(
      radius: 16,
      color: color ?? '#FFFFEDED',
      width: width,
      height: height,
      child: const AnimatedPlaceholder(),
    );
  }

  static Widget getPlaceholder(String title, int width, int height) {
    return DivCustom(
      height: height.toDouble(),
      width: width.toDouble(),
      x: '',
      color: '#FFE0E6FF',
      child: TextCustom(
        scale: 0.6,
        text: title,
        textAlign: TextAlign.center,
        size: 28,
        color: '#FFA8B8FD', key: null,
      ),
    );
  }
}

class AnimatedPlaceholder extends StatefulWidget {
  const AnimatedPlaceholder({super.key});

  @override
  State<AnimatedPlaceholder> createState() => _AnimatedPlaceholderState();
}

class _AnimatedPlaceholderState extends State<AnimatedPlaceholder>
    with TickerProviderStateMixin {
  late final Animation<double> _animation;
  late final AnimationController _controller;
  final List<String> _assetList = <String>[];

  @override
  void initState() {
    super.initState();

    for (var i = 0; i <= 39; i++) {
      _assetList.add('images/image_placeholder${i.toString().padLeft(2, '0')}.png');
    }

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reset();
      } else if (status == AnimationStatus.dismissed) {
        _controller.forward();
      }
    });

    _animation = Tween<double>(
      begin: 0,
      end: (_assetList.length - 1).toDouble(),
    ).animate(_controller)
      ..addListener(() => setState(() {}));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final int idx = _animation.value.floor().clamp(0, _assetList.length - 1);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Image.asset(
          _assetList[idx],
          gaplessPlayback: true,
          width: getSize(150),
          height: getSize(45),
        ),
      ],
    );
  }
}
