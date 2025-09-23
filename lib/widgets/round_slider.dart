import 'package:flutter/material.dart';

class RoundSliderTrackShape extends SliderTrackShape {
  const RoundSliderTrackShape(
      {this.disabledThumbGapWidth = 2.0, this.radius = 0});

  final double disabledThumbGapWidth;
  final double radius;

  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    Offset offset = Offset.zero,
    bool isEnabled = true,     // ✅ 设默认值，保持可选
    bool isDiscrete = false,   // ✅ 设默认值，保持可选
  }) {
    // overlayShape 在新版本可能为可空，安全兜底
    final double overlayWidth =
        (sliderTheme.overlayShape?.getPreferredSize(isEnabled, isDiscrete).width) ?? 0.0;

    // trackHeight 现在是 double?，给个默认高度
    final double trackHeight = sliderTheme.trackHeight ?? 2.0;

    assert(overlayWidth >= 0);
    assert(trackHeight >= 0);
    assert(parentBox.size.width >= overlayWidth);

    final double trackLeft = offset.dx + overlayWidth / 2;
    final double trackTop  = offset.dy + (parentBox.size.height - trackHeight) / 2;
    final double trackWidth = parentBox.size.width - overlayWidth;

    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }

  @override
  void paint(
      PaintingContext context,
      Offset offset, {
        required RenderBox parentBox,
        required SliderThemeData sliderTheme,
        required Animation<double> enableAnimation,
        required TextDirection textDirection,
        required Offset thumbCenter,
        Offset? secondaryOffset,      // 3.35 新增，可为 null
        bool isDiscrete = false,      // 仍为可选，给默认值
        bool isEnabled = true,        // 仍为可选，给默认值
      }) {
    // trackHeight 现在是 double?，兜底并支持 0 早退
    final double trackHeight = sliderTheme.trackHeight ?? 2.0;
    if (trackHeight == 0) {
      return;
    }

    // ColorTween.evaluate 返回 Color? —— 做兜底
    final Color activeColor = (ColorTween(
      begin: sliderTheme.disabledActiveTrackColor,
      end: sliderTheme.activeTrackColor,
    ).evaluate(enableAnimation)) ?? (sliderTheme.activeTrackColor ?? const Color(0xFF000000));

    final Color inactiveColor = (ColorTween(
      begin: sliderTheme.disabledInactiveTrackColor,
      end: sliderTheme.inactiveTrackColor,
    ).evaluate(enableAnimation)) ?? (sliderTheme.inactiveTrackColor ?? const Color(0x33000000));

    final Paint activePaint = Paint()..color = activeColor;
    final Paint inactivePaint = Paint()..color = inactiveColor;

    late Paint leftTrackPaint;
    late Paint rightTrackPaint;

    switch (textDirection) {
      case TextDirection.ltr:
        leftTrackPaint = activePaint;
        rightTrackPaint = inactivePaint;
        break;
      case TextDirection.rtl:
        leftTrackPaint = inactivePaint;
        rightTrackPaint = activePaint;
        break;
    }

    double horizontalAdjustment = 0.0;
    if (!isEnabled) {
      // thumbShape 可能为 null，getPreferredSize 也在新版里可空 —— 全部兜底
      final double disabledThumbRadius =
          (sliderTheme.thumbShape?.getPreferredSize(false, isDiscrete).width ?? 0.0) / 2.0;

      // 你原代码里的 disabledThumbGapWidth / radius 应该是你类中的字段或常量
      // 这里假设它们存在；若没有，请自定义一个合适的默认值
      final double gap = disabledThumbGapWidth * (1.0 - enableAnimation.value);
      horizontalAdjustment = disabledThumbRadius + gap;
    }

    // 注意：getPreferredRect 在 3.35 的签名也变了，见文末同步更新
    final Rect trackRect = getPreferredRect(
      parentBox: parentBox,
      sliderTheme: sliderTheme,
      offset: offset,
      isEnabled: isEnabled,
      isDiscrete: isDiscrete,
    );

    // 两端圆角（假定你类里有 radius 字段；如无可改为常量）
    final RRect leftTrackSegment = RRect.fromLTRBR(
      trackRect.left,
      trackRect.top,
      (thumbCenter.dx - horizontalAdjustment).clamp(trackRect.left, trackRect.right),
      trackRect.bottom,
      Radius.circular(radius),
    );
    context.canvas.drawRRect(leftTrackSegment, leftTrackPaint);

    final RRect rightTrackSegment = RRect.fromLTRBR(
      (thumbCenter.dx + horizontalAdjustment).clamp(trackRect.left, trackRect.right),
      trackRect.top,
      trackRect.right,
      trackRect.bottom,
      Radius.circular(radius),
    );
    context.canvas.drawRRect(rightTrackSegment, rightTrackPaint);

    // 可选：如果你想利用 secondaryOffset（比如 RangeSlider 第二个拇指），可以在此画“第二段”
    // if (secondaryOffset != null) { ... }
  }

}
