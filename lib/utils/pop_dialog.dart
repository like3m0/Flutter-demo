import 'dart:core';
import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:xiangyue/bluetooth/bluetooth_channel.dart';
import 'package:xiangyue/utils/screen_util.dart';
import 'package:xiangyue/widgets/custom/div_custom.dart';
import 'package:xiangyue/widgets/custom/image_custom.dart';
import 'package:xiangyue/widgets/custom/text_custom.dart';

class _PopDialog extends Dialog {
  final VoidCallback? dismissCallback; // 用 VoidCallback 更合适
  final Widget? child;
  final bool outsideDismiss;
  final bool backDismiss;

  _PopDialog(
      {Key? key,
      this.child,
      this.outsideDismiss = false,
      this.backDismiss = false,
      this.dismissCallback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    _dismissDialog() {
      if (dismissCallback != null) {
        dismissCallback!();
      }
      Navigator.of(context).pop();
    }

    return WillPopScope(
      onWillPop: () async {
        if (backDismiss) {
          if (dismissCallback != null) {
            dismissCallback!();
          }
        }
        return Future.value(backDismiss);
      },
      child: GestureDetector(
        onTap: outsideDismiss ? _dismissDialog : null,
        child: Material(
          color: Color(0x00000000),
          child: child,
        ),
      ),
    );
  }
}

showCustomDialog(BuildContext context, Widget child,
    {Key? key,
    bool outsideDismiss = false,
    bool backDismiss = false,
    VoidCallback? dismissCallback, // 改成可空的 VoidCallback
    Color barrierColor = const Color(0xBB000000),
    bool showCloseButton = true}) {
  showGeneralDialog(
    context: context,
    pageBuilder: (BuildContext buildContext, Animation<double> animation,
        Animation<double> secondaryAnimation) {
      return _PopDialog(
        outsideDismiss: outsideDismiss,
        backDismiss: backDismiss,
        dismissCallback: dismissCallback,
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: [
            DivCustom(
              scale: 0.7,
              width: 317,
              color: "#FFFFFFFF",
              radius: 15,
              child: Stack(
                children: [
                  DivCustom(
                    scale: 0.7,
                    padding: [30, 0, 20],
                    child: child,
                  ),
                  if (showCloseButton)
                    Positioned(
                      top: getSize(4),
                      right: getSize(4),
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: ImageCustom(
                          width: 29.5,
                          name: "dialog_close",
                        ),
                      ),
                    )
                ],
              ),
            ),
          ],
        ),
      );
    },
    barrierDismissible: false,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor: barrierColor,
    transitionDuration: const Duration(milliseconds: 150),
  );
}

showNotifyDialog(BuildContext context, String notifyText,
    {VoidCallback? dismssCallback, VoidCallback? actionCallback}) {
  showGeneralDialog(
    context: context,
    pageBuilder: (BuildContext buildContext, Animation<double> animation,
        Animation<double> secondaryAnimation) {
      return _PopDialog(
          outsideDismiss: false,
          backDismiss: false,
          child: Center(
            child: DivCustom(
              width: 334,
              height: 164,
              child: Stack(children: [
                ImageCustom(
                    width: 334, name: "dlg_bg", boxFit: BoxFit.fitWidth),
                Positioned(
                    top: getSize(10),
                    left: getSize(30),
                    bottom: getSize(60),
                    right: getSize(30),
                    child: DivCustom(
                      child: Text(
                        notifyText,
                        textAlign: TextAlign.center,
                        textDirection: TextDirection.ltr,
                        maxLines: 10,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: getSize(18),
                            height: 1.3,
                            fontWeight: FontWeight.w400),
                      ),
                    )),
                Positioned(
                    top: getSize(110),
                    left: getSize(8),
                    child: DivCustom(
                        width: 315,
                        height: 2,
                        color: "0xff555555",
                        child: null)),
                Positioned(
                    left: getSize(10),
                    right: getSize(10),
                    bottom: getSize(10),
                    child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                          RFCommChannel.isToast = false;
                        },
                        child: DivCustom(
                          width: 313,
                          height: 40,
                          child: Text(
                            "OK",
                            textAlign: TextAlign.start,
                            textDirection: TextDirection.ltr,
                            maxLines: 10,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: getSize(22),
                                fontWeight: FontWeight.w400),
                          ),
                        ))),
              ]),
            ),
          ));
    },
    barrierDismissible: false,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor: Color(0x00000000),
    transitionDuration: const Duration(milliseconds: 150),
  );
}

showCashbackDialog(BuildContext context, String userName, String amount,
    {VoidCallback? dismssCallback, VoidCallback? actionCallback}) {
  showGeneralDialog(
    context: context,
    pageBuilder: (BuildContext buildContext, Animation<double> animation,
        Animation<double> secondaryAnimation) {
      return _PopDialog(
        outsideDismiss: false,
        backDismiss: false,
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: ImageCustom(
                name: "dialog_ribbon",
              ),
            ),
            Stack(
              alignment: AlignmentDirectional.center,
              children: [
                DivCustom(
                  scale: 0.7,
                  margin: [71],
                  width: 260,
                  color: "#FFFFFFFF",
                  radius: 20,
                  padding: [30],
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextCustom(
                        scale: 0.7,
                        text: "恭喜您！获得返现",
                        color: "#FF333333",
                        weight: FontWeight.bold,
                        size: 16,
                      ),
                      TextCustom(
                        scale: 0.7,
                        text: "因为您的推荐\n用户 $userName\n也成为了十分科学的VIP一员",
                        color: "#FF666666",
                        size: 14,
                        margin: [23, 0, 0],
                        textAlign: TextAlign.center,
                      ),
                      TextCustom(
                        scale: 0.7,
                        text: "¥$amount",
                        color: "#FFFC5A39",
                        size: 40,
                        weight: FontWeight.w700,
                        margin: [0, 0, 16],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: dismssCallback,
                            child: DivCustom(
                              scale: 0.7,
                              width: 90,
                              height: 34,
                              radius: 34 / 2,
                              color: "#FFFFA91C",
                              x: "center",
                              child: TextCustom(
                                scale: 0.7,
                                text: "开心收下",
                                size: 16,
                                color: "#FFFFFFFF",
                                weight: FontWeight.w500,
                              ),
                            ),
                          ),
                          SizedBox(width: getSize(13)),
                          GestureDetector(
                            onTap: actionCallback,
                            child: DivCustom(
                              scale: 0.7,
                              width: 121,
                              height: 34,
                              radius: 34 / 2,
                              color: "#FFFFAA1C",
                              x: "center",
                              child: TextCustom(
                                scale: 0.7,
                                text: "立即提现",
                                size: 16,
                                color: "#FFFFFFFF",
                                weight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: getSize(32))
                    ],
                  ),
                ),
                Positioned(
                  top: 0,
                  child: ImageCustom(
                    height: 90,
                    name: "dialog_cashback_icon",
                  ),
                ),
                Positioned(
                  top: getSize(82),
                  right: getSize(25),
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: ImageCustom(
                      width: 30,
                      name: "dialog_cancel",
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      );
    },
    barrierDismissible: true,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor: Color(0xBB000000),
    transitionDuration: const Duration(milliseconds: 150),
  );
}

showCashbackDescriptionDialog(BuildContext context) {
  showGeneralDialog(
    context: context,
    pageBuilder: (BuildContext buildContext, Animation<double> animation,
        Animation<double> secondaryAnimation) {
      return _PopDialog(
        outsideDismiss: true,
        backDismiss: false,
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: [
            DivCustom(
              scale: 0.7,
              width: 260,
              height: 356,
              radius: 20,
              color: "#FFFFFFFF",
              padding: [28],
              child: Column(
                children: [
                  TextCustom(
                    scale: 0.7,
                    text: "规则",
                    size: 16,
                    color: "#FF333333",
                    weight: FontWeight.bold,
                  ),
                  TextCustom(
                    scale: 0.7,
                    width: 209,
                    text:
                        "1. 每邀请一位新用户注册并购买终身VIP即可获得返现奖励50元。\n2.绑定微信及满足一定提现金额后即可在提现页面提现到微信。\n3.本返现奖励为系统自动核实发放，不可转让，赠予他人。\n4.选择提现金额，但实际返现金额不足时不可提现。\n5.本活动最终解释权归北京现在科技有限公司所有。",
                    size: 14,
                    color: "#FF666666",
                    margin: [25, 0, 23],
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: DivCustom(
                      scale: 0.7,
                      width: 121,
                      height: 34,
                      color: "#FFFFA91C",
                      radius: 17,
                      x: "center",
                      child: TextCustom(
                        scale: 0.7,
                        text: "知道了",
                        size: 16,
                        color: "#FFFFFFFF",
                        weight: FontWeight.w500,
                      ),
                    ),
                  )
                ],
              ),
            ),
            Positioned(
              top: getSize(82),
              right: getSize(25),
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: ImageCustom(
                  width: 30,
                  name: "dialog_cancel",
                ),
              ),
            )
          ],
        ),
      );
    },
    barrierDismissible: true,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor: Color(0xBB000000),
    transitionDuration: const Duration(milliseconds: 150),
  );
}

showAchieveShareDialog(BuildContext context) {
  showCustomDialog(
      context,
      Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextCustom(
            scale: 0.7,
            text: "太厉害了，快把这个成就\n分享给其他小朋友吧!",
            color: "#FF2E2E2E",
            size: 19,
            weight: FontWeight.w500,
            textAlign: TextAlign.center,
          ),
          ImageCustom(
            margin: [26, 0, 7],
            width: 172,
            name: "dialog_achieve",
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextCustom(
                scale: 0.7,
                text: "已有281323人分享",
                color: "#FF434343",
                size: 15,
              )
            ],
          ),
          GestureDetector(
            onTap: () {},
            child: DivCustom(
              scale: 0.7,
              margin: [16],
              width: 176,
              height: 41,
              radius: 41 / 2,
              color: "#FFFFAA1C",
              x: "center",
              child: TextCustom(
                scale: 0.7,
                text: "分享给其他人",
                size: 20,
                color: "#FFFFFFFF",
                weight: FontWeight.w500,
              ),
            ),
          )
        ],
      ));
}

showDiamondDialog(BuildContext context,
    {String? title,
    String? imageName,
    String? actionTitle,
    Function? onActionClick,
    String? content}) {
  showGeneralDialog(
    context: context,
    pageBuilder: (BuildContext buildContext, Animation<double> animation,
        Animation<double> secondaryAnimation) {
      return _PopDialog(
        outsideDismiss: false,
        backDismiss: false,
        // dismissCallback: dismissCallback,
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: [
            DivCustom(
              scale: 0.7,
              margin: [37],
              radius: 18,
              width: 260,
              height: 173,
              color: "#FFFFFFFF",
              x: "center",
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextCustom(
                    scale: 0.7,
                    width: 206,
                    text: title ?? '',
                    color: "#FF333333",
                    weight: FontWeight.bold,
                    size: 16,
                    margin: [52],
                    textAlign: TextAlign.center,
                  ),
                  if (content != null)
                    TextCustom(
                      scale: 0.7,
                      width: 206,
                      text: content,
                      color: "#FF777777",
                      size: 13,
                      margin: [3, 0, 4],
                      textAlign: TextAlign.center,
                    ),
                  GestureDetector(
                    onTap: () => onActionClick!(),
                    child: DivCustom(
                      scale: 0.7,
                      margin: [0, 0, 22],
                      width: 226,
                      height: 34,
                      color: "#FFFFA91C",
                      radius: 18,
                      x: "center",
                      child: TextCustom(
                          scale: 0.7,
                          text: actionTitle ?? '',
                          color: "#FFFFFFFF",
                          weight: FontWeight.w500,
                          size: 16),
                    ),
                  )
                ],
              ),
            ),
            Positioned(
              child: ImageCustom(
                margin: [0, 0, 129],
                height: 81,
                name: imageName,
              ),
            )
          ],
        ),
      );
    },
    barrierDismissible: false,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    transitionDuration: const Duration(milliseconds: 150),
  );
}

showExperimentGuide(BuildContext context, {VoidCallback? dismissCallback}) {
  showGeneralDialog(
    context: context,
    pageBuilder: (BuildContext buildContext, Animation<double> animation,
        Animation<double> secondaryAnimation) {
      return _PopDialog(
        outsideDismiss: true,
        backDismiss: false,
        dismissCallback: dismissCallback,
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: [
            DivCustom(
              scale: 0.7,
              margin: [50],
              width: 260,
              height: 224,
              color: "#FFFFFFFF",
              radius: 20,
              padding: [35],
              child: Column(
                children: [
                  TextCustom(
                    scale: 0.7,
                    text: "科学离不开实验",
                    color: "#FF333333",
                    weight: FontWeight.bold,
                    size: 16,
                  ),
                  TextCustom(
                    scale: 0.7,
                    text: "每一节系统课都有一节对应\n的实验课，建议您购买实验\n盒子提升学习体验",
                    color: "#FF666666",
                    size: 14,
                    margin: [21, 0, 26],
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      dismissCallback!();
                    },
                    child: DivCustom(
                      scale: 0.7,
                      color: "#FFFFA91C",
                      width: 121,
                      height: 34,
                      radius: 18,
                      x: "center",
                      child: TextCustom(
                        scale: 0.7,
                        text: "我知道了",
                        color: "#FFFFFFFF",
                        size: 16,
                        weight: FontWeight.w500,
                      ),
                    ),
                  )
                ],
              ),
            ),
            ImageCustom(
              margin: [0, 0, 200],
              width: 65,
              name: "exoeriment_guide_icon",
            ),
            Positioned(
              top: getSize(82),
              right: getSize(25),
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  dismissCallback!();
                },
                child: ImageCustom(
                  width: 30,
                  name: "dialog_cancel",
                ),
              ),
            )
          ],
        ),
      );
    },
    barrierDismissible: false,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor: Color(0xBB000000),
    transitionDuration: const Duration(milliseconds: 150),
  );
}

showMicphonePermission(BuildContext context,
    {VoidCallback? dismissCallback, VoidCallback? clickCallback}) {
  showGeneralDialog(
    context: context,
    pageBuilder: (BuildContext buildContext, Animation<double> animation,
        Animation<double> secondaryAnimation) {
      return _PopDialog(
        outsideDismiss: true,
        backDismiss: false,
        dismissCallback: dismissCallback,
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: [
            DivCustom(
              scale: 0.7,
              width: 260,
              height: 167,
              color: "#FFFFFFFF",
              radius: 20,
              padding: 35,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextCustom(
                      scale: 0.7,
                      text: "请到设置里面，打开麦克风的权限。",
                      color: "#FF333333",
                      size: 16,
                      weight: FontWeight.bold),
                  GestureDetector(
                    onTap: clickCallback,
                    child: DivCustom(
                      scale: 0.7,
                      width: 226,
                      height: 34,
                      radius: 34 / 2,
                      x: "center",
                      color: "#FFFFA91C",
                      child: TextCustom(
                        scale: 0.7,
                        text: "确定",
                        color: "#FFFFFFFF",
                        weight: FontWeight.w500,
                        size: 16,
                      ),
                    ),
                  )
                ],
              ),
            ),
            Positioned(
              top: getSize(82),
              right: getSize(25),
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  dismissCallback!();
                },
                child: ImageCustom(
                  width: 30,
                  name: "dialog_cancel",
                ),
              ),
            )
          ],
        ),
      );
    },
    barrierDismissible: false,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor: Color(0xBB000000),
    transitionDuration: const Duration(milliseconds: 150),
  );
}

showParentValidDialog(BuildContext context,
    {VoidCallback? dismissCallback, VoidCallback? validSuccess}) {
  if (!Platform.isIOS) {
    validSuccess!();
  }

  final List<String> _cnUpperNumber = [
    "壹",
    "贰",
    "叁",
    "肆",
    "伍",
    "陆",
    "柒",
    "捌",
    "玖"
  ];
  List tmp = List.generate(8, (i) => i);
  tmp.shuffle();
  List selectedNum = [];

  showGeneralDialog(
    context: context,
    pageBuilder: (BuildContext buildContext, Animation<double> animation,
        Animation<double> secondaryAnimation) {
      return _PopDialog(
        outsideDismiss: false,
        backDismiss: false,
        child: StatefulBuilder(
          builder: (context, state) {
            return Stack(
              alignment: AlignmentDirectional.center,
              children: [
                DivCustom(
                  scale: 0.7,
                  width: 296,
                  height: 334,
                  color: "#FFFFFFFF",
                  radius: 20,
                  child: Column(
                    children: [
                      TextCustom(
                        scale: 0.7,
                        margin: [26, 0, 20],
                        text: "家长验证",
                        color: "#FF333333",
                        weight: FontWeight.bold,
                        size: 16,
                        textAlign: TextAlign.center,
                      ),
                      TextCustom(
                        scale: 0.7,
                        margin: [0, 0, 28],
                        text:
                            "请依次输入：${_cnUpperNumber[tmp[0]]}、${_cnUpperNumber[tmp[1]]}",
                        color: "#FFF19100",
                        weight: FontWeight.w500,
                        size: 15,
                        textAlign: TextAlign.center,
                      ),
                      DivCustom(
                        scale: 0.7,
                        padding: [0, 38, 0, 38],
                        child: Wrap(
                          runSpacing: getSize(22),
                          spacing: getSize(38),
                          children: [1, 2, 3, 4, 5, 6, 7, 8, 9]
                              .map<Widget>((e) => GestureDetector(
                                    onTap: () {
                                      int num = e - 1;
                                      if (selectedNum.contains(num)) {
                                        selectedNum.remove(num);
                                      } else if (selectedNum.length < 2) {
                                        selectedNum.add(num);
                                      }
                                      state(() {});
                                      if ([tmp[0], tmp[1]]
                                              .contains(selectedNum[0]) &&
                                          [tmp[0], tmp[1]]
                                              .contains(selectedNum[1])) {
                                        validSuccess!();
                                      }
                                    },
                                    child: DivCustom(
                                      scale: 0.7,
                                      width: 48,
                                      height: 48,
                                      color: selectedNum.contains(e - 1)
                                          ? "#FFF19100"
                                          : "#FFFFF8DD",
                                      radius: 24,
                                      x: "center",
                                      child: TextCustom(
                                        scale: 0.7,
                                        text: e.toString(),
                                        color: selectedNum.contains(e - 1)
                                            ? "#FFFFFFFF"
                                            : "#FFF19100",
                                        weight: FontWeight.w500,
                                        size: 21,
                                      ),
                                    ),
                                  ))
                              .toList(),
                        ),
                      )
                    ],
                  ),
                ),
                Positioned(
                  top: getSize(82),
                  right: getSize(25),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      dismissCallback!();
                    },
                    child: ImageCustom(
                      width: 30,
                      name: "dialog_cancel",
                    ),
                  ),
                )
              ],
            );
          },
        ),
      );
    },
    barrierDismissible: false,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor: Color(0xBB000000),
    transitionDuration: const Duration(milliseconds: 150),
  );
}
