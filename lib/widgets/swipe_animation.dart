import 'package:flutter/material.dart';
import 'package:xiangyue/utils/screen_util.dart';
import 'package:xiangyue/widgets/custom/div_custom.dart';
import 'package:xiangyue/widgets/custom/image_custom.dart';
import 'dart:math' as math;
import 'package:simple_animations/simple_animations.dart';

class SwipeAnimation extends StatelessWidget {
  SwipeAnimation();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: DivCustom(
        width: 124,
        height: 72,
        child: Stack(
          alignment: AlignmentDirectional.bottomCenter,
          children: [
            Positioned(
              top: 0,
              left: 0,
              child: ImageCustom(
                width: 44.12,
                name: "swipe_animation_arrow",
              ),
            ),
            Positioned(
                top: 0,
                right: 0,
                child: Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.rotationY(math.pi),
                  child: ImageCustom(
                    width: 44.12,
                    name: "swipe_animation_arrow",
                  ),
                )),
            LoopAnimation(
                tween: TweenSequence<double>([
                  TweenSequenceItem<double>(
                      tween: Tween(begin: -1, end: 1), weight: 1),
                  TweenSequenceItem<double>(
                      tween: Tween(begin: 1, end: -1), weight: 1),
                ]),
                duration: Duration(milliseconds: 1500),
                builder: (context, child, value) {
                  return Transform.translate(
                    offset: Offset(value * getSize(20), 0),
                    child: ImageCustom(
                      width: 43.5,
                      name: "swipe_animation_hand",
                    ),
                  );
                })
          ],
        ),
      ),
    );
  }
}
