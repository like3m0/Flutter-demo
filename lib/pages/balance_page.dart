import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flustars/flustars.dart';
import 'package:xiangyue/bluetooth/audio_status.dart';
import 'package:xiangyue/bluetooth/bluetooth_channel.dart';
import 'package:xiangyue/bluetooth/data_pack.dart';
import 'package:xiangyue/utils/screen_util.dart';
import 'package:xiangyue/widgets/custom/div_custom.dart';
import 'package:xiangyue/widgets/custom/image_custom.dart';
import 'package:xiangyue/widgets/custom/text_custom.dart';
import 'package:provider/provider.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
import 'dart:math';
import 'dart:core';

class BalancePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _BalancePageState();
  }
}

class _BalancePageState extends State<BalancePage> {
  Color activeTrackBarColor = Color(0xFF0B90D9);
  Color inactiveTrackBarColor = Color(0xFFFF5E21);
  bool isDragging = false;
  Timer tDragging = null;
  Timer tDragging1 = null;
  Timer tDragging2 = null;
  int dragBar = -1;

  bool centerButtonPressed = false;

  AudioStatus au = null;

  @override
  void initState() {
    super.initState();
    this.au = Provider.of<AudioStatus>(context, listen: false);
  }

  void dispose() {
    super.dispose();
  }

  String formatBalance(num value) {
    var x = value.round();
    if (x == 0) {
      return "Center";
    }
    if (x < 0) {
      return "Left${-x}";
    } else {
      return "Right$x";
    }
  }

  String formatFader(num value) {
    var x = value.round();
    if (x == 0) {
      return "Center";
    }
    if (x < 0) {
      return "Front${-x}";
    } else {
      return "Rear$x";
    }
  }

  Widget _buildBody(BuildContext ctx) {
    var height = ScreenUtil.getScreenH(ctx);
    var appBarHeight = ScreenUtil.getStatusBarH(ctx);
    var statusHeight = ScreenUtil.getStatusBarH(ctx);
    var usableHeight = (height - appBarHeight - statusHeight) /
        ScreenUtil.getInstance().getRatio();
    usableHeight -= 300;
    usableHeight -= 50;
    // usableHeight -= 180;
    if (usableHeight - 10 >= 335) {
      usableHeight = 335;
    } else {
      usableHeight -= 10;
    }
    // usableHeight = 280;
    var gridSize = (usableHeight * 290 / 335).floor();
    var fontSize = (16 * usableHeight / 335).floor();
    var space = (gridSize / 22).floor();
    var begin = ((gridSize % 22) / 2).floor();
    var end = gridSize - space * 22 - begin;
    // print("gridSize:$gridSize,space:$space, begin:$begin, end: $end");
    // print("screen width:${ScreenUtil.getScreenW(ctx)}");
    // print("screen height:$height");
    // print("appBarHeight height:$appBarHeight");
    // print("statusHeight height:$statusHeight");
    // print("ratio:${ScreenUtil.getInstance().getRatio()}");
    // print("usableHeight height:$usableHeight");
    return Consumer<AudioStatus>(
        builder: (BuildContext context, AudioStatus audioStatus, Widget child) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          DivCustom(
              margin: [0, 0, 0, 0],
              child: Stack(
                children: [
                  ImageCustom(
                      x: "0",
                      y: "0",
                      name: "bg_diban",
                      width: usableHeight,
                      boxFit: BoxFit.fitWidth),
                  Positioned(
                    top: (35 * usableHeight / 335),
                    left: 0,
                    right: 0,
                    child: TextCustom(
                        color: "0xffb2b2b2",
                        size: fontSize.toDouble(),
                        text:
                            "Fader:${this.formatFader(audioStatus.Fader - 11)}  Balance:${this.formatBalance(audioStatus.Balance - 11)}"),
                  ),
                  GestureDetector(
                      onTapDown: (e) {
                        if (this.isDragging) return;
                        print(
                            "tap down ${e.localPosition.dx}, ${e.localPosition.dy}");
                        var x = e.localPosition.dx - 70;
                        var y = e.localPosition.dy - 60;
                        var p_x = begin + (audioStatus.Balance) * space;
                        var p_y = begin + (audioStatus.Fader) * space;
                        print("x:$x,p_x:$p_x,y:$y,p_y:$p_y");
                        var dx = x - p_x;
                        var dy = y - p_y;
                        if (sqrt(dx * dx + dy * dy) < 100) {
                          this.isDragging = true;
                          //立即发送一次
                          DataPack dp = DataPack.initFaderBalanceData(
                              audioStatus.Fader, audioStatus.Balance);
                          RFCommChannel.requestChannelSilent(dp);
                          if (this.tDragging != null) {
                            this.tDragging.cancel();
                            this.tDragging = null;
                          }
                          if (tDragging == null) {
                            this.tDragging = Timer.periodic(
                                Duration(milliseconds: 500), (timer) {
                              print(
                                  "${audioStatus.Balance},${audioStatus.Fader}");
                              DataPack dp = DataPack.initFaderBalanceData(
                                  audioStatus.Fader, audioStatus.Balance);
                              RFCommChannel.requestChannel(dp);
                            });
                          }
                        }
                      },
                      onPanUpdate: (e) {
                        if (!isDragging) return;
                        var balance =
                            ((e.localPosition.dx - 70) / space).round();
                        balance = balance - 11;
                        var fader = ((e.localPosition.dy - 60) / space).round();
                        fader = fader - 11;
                        if (balance < -11) balance = -11;
                        if (balance > 11) balance = 11;
                        if (fader < -11) fader = -11;
                        if (fader > 11) fader = 11;
                        print("fader:$fader,balance:$balance");
                        this.au.setFaderAndBalance(fader + 11, balance + 11);
                      },
                      onPanCancel: () {
                        print("pan cancel in custom");
                        if (this.tDragging != null) {
                          tDragging.cancel();
                          tDragging = null;
                        }
                        this.isDragging = false;
                        DataPack dp = DataPack.initFaderBalanceData(
                            audioStatus.Fader, audioStatus.Balance);
                        RFCommChannel.requestChannel(dp);
                      },
                      onPanEnd: (e) {
                        print("pan end in custom");
                        if (this.tDragging != null) {
                          tDragging.cancel();
                          tDragging = null;
                        }
                        this.isDragging = false;
                        DataPack dp = DataPack.initFaderBalanceData(
                            audioStatus.Fader, audioStatus.Balance);
                        RFCommChannel.requestChannel(dp);
                      },
                      child: DivCustom(
                          margin: [
                            38 * (gridSize / 290),
                            0,
                            0,
                            (375 - gridSize) / 2
                          ],
                          width: gridSize,
                          height: gridSize,
                          color: "#00000000",
                          child: CustomPaint(
                            painter: GridPainter(
                                (audioStatus.Balance - 11).toDouble(),
                                (audioStatus.Fader - 11).toDouble()),
                            isComplex: false,
                            willChange: true,
                            size:
                                Size(gridSize.toDouble(), gridSize.toDouble()),
                          )))
                ],
              )),
          GestureDetector(
              onTapDown: (e) {
                print("tap center");
                if (this.centerButtonPressed) {
                  return;
                }
                this.centerButtonPressed = true;
                this.setState(() {});
              },
              onTapUp: (e) {
                DataPack dp = DataPack.initFaderBalanceData(11, 11);
                RFCommChannel.requestChannel(dp);
                this.au.setFaderAndBalance(11, 11);
                Future.delayed(Duration(milliseconds: 100), () {
                  this.centerButtonPressed = false;
                  setState(() {});
                });
              },
              onTapCancel: () {
                Future.delayed(Duration(milliseconds: 100), () {
                  this.centerButtonPressed = false;
                  setState(() {});
                });
              },
              child: DivCustom(
                  margin: [0, 0, 0, usableHeight - 80],
                  width: 80,
                  child: ImageCustom(
                      name: this.centerButtonPressed
                          ? "btn_center_1"
                          : "btn_center",
                      width: 80,
                      height: 40))),
          DivCustom(
              margin: [0, 20, 0, 20],
              child: Stack(children: [
                ImageCustom(
                  padding: [13, 0, 0, 0],
                  name: "k_kedu",
                  width: 335,
                  boxFit: BoxFit.fitWidth,
                ),
                DivCustom(
                  padding: [0, 5, 0, 5],
                  child: FlutterSlider(
                    min: -5,
                    max: 5,
                    values: [(audioStatus.Bass - 5) * 1.0],
                    step: FlutterSliderStep(step: 1),
                    selectByTap: false,
                    centeredOrigin: true,
                    trackBar: FlutterSliderTrackBar(
                      inactiveTrackBarHeight: getSize(30),
                      activeTrackBarHeight: getSize(30),
                      activeTrackBar: BoxDecoration(
                        color: Colors.transparent,
                        border: Border(
                            bottom: BorderSide(
                                color: this.dragBar != 1
                                    ? activeTrackBarColor
                                    : inactiveTrackBarColor,
                                style: BorderStyle.solid)),
                      ),
                      inactiveTrackBar:
                          BoxDecoration(color: Colors.transparent),
                    ),
                    handler: FlutterSliderHandler(
                        decoration: BoxDecoration(color: Colors.transparent),
                        child: ImageCustom(
                            name: this.dragBar != 1
                                ? "slider_blue"
                                : "slider_orange",
                            width: 25,
                            boxFit: BoxFit.fitWidth)),
                    handlerAnimation: FlutterSliderHandlerAnimation(
                        curve: Curves.elasticOut,
                        reverseCurve: Curves.bounceIn,
                        duration: Duration(milliseconds: 500),
                        scale: 1),
                    onDragStarted: (handlerIndex, lowerValue, upperValue) {
                      this.dragBar = 1;
                      var bass = lowerValue.round();
                      DataPack dp =
                          DataPack.initBassControlData(audioStatus.Bass);
                      RFCommChannel.requestChannelSilent(dp);
                      if (this.tDragging1 != null) {
                        this.tDragging1.cancel();
                        this.tDragging1 = null;
                      }
                      this.tDragging1 =
                          Timer.periodic(Duration(milliseconds: 500), (timer) {
                        print("dragging timer");
                        DataPack dp =
                            DataPack.initBassControlData(audioStatus.Bass);
                        RFCommChannel.requestChannelSilent(dp);
                      });
                      this.au.setBass(bass + 5);
                    },
                    onDragging: (handlerIndex, lowerValue, upperValue) {
                      var bass = lowerValue.round();
                      this.au.setBass(bass + 5);
                    },
                    onDragCompleted: (handlerIndex, lowerValue, upperValue) {
                      this.dragBar = -1;
                      if (tDragging1 != null) {
                        tDragging1.cancel();
                        tDragging1 = null;
                      }
                      var bass = lowerValue.round();
                      this.au.setBass(bass + 5);
                      DataPack dp = DataPack.initBassControlData(bass + 5);
                      RFCommChannel.requestChannel(dp);
                    },
                  ),
                ),
                Positioned(
                  left: 0,
                  top: 0,
                  width: getSize(110),
                  height: getSize(10),
                  child: TextCustom(
                    text: "Bass: ${audioStatus.Bass - 5} step",
                    color: "#ffffffff",
                    size: 16,
                    textAlign: TextAlign.left,
                  ),
                ),
              ])),
          DivCustom(
              margin: [15, 20, 0, 20],
              child: Stack(children: [
                ImageCustom(
                  padding: [13, 0, 0, 0],
                  name: "k_kedu",
                  width: 335,
                  boxFit: BoxFit.fitWidth,
                ),
                DivCustom(
                  padding: [0, 5, 0, 5],
                  child: FlutterSlider(
                    min: -5,
                    max: 5,
                    values: [(audioStatus.Treble - 5) * 1.0],
                    step: FlutterSliderStep(step: 1),
                    selectByTap: false,
                    centeredOrigin: true,
                    trackBar: FlutterSliderTrackBar(
                      inactiveTrackBarHeight: getSize(30),
                      activeTrackBarHeight: getSize(30),
                      activeTrackBar: BoxDecoration(
                          color: Colors.transparent,
                          border: Border(
                              bottom: BorderSide(
                                  color: this.dragBar != 2
                                      ? activeTrackBarColor
                                      : inactiveTrackBarColor,
                                  style: BorderStyle.solid))),
                      inactiveTrackBar:
                          BoxDecoration(color: Colors.transparent),
                    ),
                    handler: FlutterSliderHandler(
                        decoration: BoxDecoration(color: Colors.transparent),
                        child: ImageCustom(
                            padding: [0, 0, 0, 0],
                            name: this.dragBar != 2
                                ? "slider_blue"
                                : "slider_orange",
                            width: 25,
                            boxFit: BoxFit.fitWidth)),
                    handlerAnimation: FlutterSliderHandlerAnimation(
                        curve: Curves.elasticOut,
                        reverseCurve: Curves.bounceIn,
                        duration: Duration(milliseconds: 500),
                        scale: 1),
                    onDragStarted: (handlerIndex, lowerValue, upperValue) {
                      this.dragBar = 2;
                      var treble = lowerValue.round();
                      DataPack dp =
                          DataPack.initTrebleControlData(audioStatus.Treble);
                      RFCommChannel.requestChannelSilent(dp);
                      if (this.tDragging2 != null) {
                        this.tDragging2.cancel();
                        this.tDragging2 = null;
                      }
                      this.tDragging2 =
                          Timer.periodic(Duration(milliseconds: 500), (timer) {
                        print("dragging timer");
                        DataPack dp =
                            DataPack.initTrebleControlData(audioStatus.Treble);
                        RFCommChannel.requestChannelSilent(dp);
                      });
                      this.au.setTreble(treble + 5);
                    },
                    onDragging: (handlerIndex, lowerValue, upperValue) {
                      var treble = lowerValue.round();
                      this.au.setTreble(treble + 5);
                    },
                    onDragCompleted: (handlerIndex, lowerValue, upperValue) {
                      this.dragBar = -1;
                      if (tDragging2 != null) {
                        tDragging2.cancel();
                        tDragging2 = null;
                      }
                      var treble = lowerValue.round();
                      this.au.setTreble(treble + 5);
                      DataPack dp = DataPack.initTrebleControlData(treble + 5);
                      RFCommChannel.requestChannel(dp);
                    },
                  ),
                ),
                Positioned(
                  left: 0,
                  top: 0,
                  width: getSize(120),
                  height: getSize(10),
                  child: TextCustom(
                    text: "Treble: ${audioStatus.Treble - 5} step",
                    color: "#ffffffff",
                    size: 16,
                    textAlign: TextAlign.left,
                  ),
                ),
              ])),
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0x00000000),
      body: DivCustom(margin: [0, 0, 0, 0], child: _buildBody(context)),
    );
  }
}

class GridPainter extends CustomPainter {
  int balance = 0;
  int fader = 0;

  GridPainter(double value1, double value2) {
    this.balance = value1.round();
    this.fader = value2.round();
  }

  @override
  void paint(Canvas canvas, Size size) {
    print("${size.width},${size.height}");
    var gridSize = size.width;
    var space = (gridSize / 22).floor();
    var begin = ((gridSize % 22) / 2).floor();
    var end = gridSize - space * 22 - begin;
    end = gridSize - end;

    var gridPaint = Paint()
      ..strokeCap = StrokeCap.square
      ..isAntiAlias = true
      ..color = Color(0x11777777)
      ..strokeWidth = 1;
    var scalePaint = Paint()
      ..strokeCap = StrokeCap.square
      ..isAntiAlias = true
      ..color = Color(0x554E5154)
      ..strokeWidth = 3;
    var axisPaint = Paint()
      ..strokeCap = StrokeCap.square
      ..isAntiAlias = true
      ..color = Color(0xFF10AFEB)
      ..strokeWidth = 5;
    for (int i = 1; i <= 23; i++) {
      canvas.drawLine(
          Offset((begin - space).toDouble() + i * space, begin.toDouble()),
          Offset((begin - space).toDouble() + i * space, end.toDouble()),
          gridPaint);
      canvas.drawLine(
          Offset((begin - space).toDouble() + i * space, (end - 5).toDouble()),
          Offset((begin - space).toDouble() + i * space, end.toDouble()),
          scalePaint);
      canvas.drawLine(
          Offset(begin.toDouble(), (begin - space).toDouble() + i * space),
          Offset(end.toDouble(), (begin - space).toDouble() + i * space),
          gridPaint);
      canvas.drawLine(
          Offset(begin.toDouble(), (begin - space).toDouble() + i * space),
          Offset(
              (begin + 5).toDouble(), (begin - space).toDouble() + i * space),
          scalePaint);
      canvas.drawLine(
          Offset((end - 5).toDouble(), (begin - space).toDouble() + i * space),
          Offset(end.toDouble(), (begin - space).toDouble() + i * space),
          scalePaint);
    }
    canvas.drawLine(
        Offset((begin - space).toDouble() + 12 * space, begin.toDouble() + 2),
        Offset((begin - space).toDouble() + 12 * space, end.toDouble() - 2),
        axisPaint);
    canvas.drawLine(
        Offset(begin.toDouble() + 2, (begin - space).toDouble() + 12 * space),
        Offset(end.toDouble() - 2, (begin - space).toDouble() + 12 * space),
        axisPaint);

    // double width = 290;
    // canvas.drawLine(Offset(0, 0), Offset(0, width), axisPaint);
    // canvas.drawLine(Offset(width, 0), Offset(width, width), axisPaint);
    // canvas.drawLine(Offset(0, 0), Offset(width, 0), axisPaint);
    // canvas.drawLine(Offset(0, width), Offset(width, width), axisPaint);

    var linePaint = Paint()
      ..strokeCap = StrokeCap.square
      ..isAntiAlias = true
      ..color = Colors.white
      ..strokeWidth = 1;
    var circlePaint = Paint()
      ..strokeCap = StrokeCap.square
      ..style = PaintingStyle.fill
      ..isAntiAlias = true
      ..color = Colors.orange
      ..strokeWidth = 1;
    canvas.drawLine(
        Offset(gridSize / 2, begin.toDouble() + (this.fader + 11.0) * space),
        Offset(begin.toDouble() + (this.balance + 11.0) * space,
            begin.toDouble() + (this.fader + 11.0) * space),
        linePaint);
    canvas.drawLine(
        Offset(begin.toDouble() + (this.balance + 11.0) * space,
            begin.toDouble() + (this.fader + 11.0) * space),
        Offset(begin.toDouble() + (this.balance + 11.0) * space, gridSize / 2),
        linePaint);
    canvas.drawCircle(
        Offset(begin.toDouble() + (this.balance + 11.0) * space,
            begin.toDouble() + (this.fader + 11.0) * space),
        6,
        circlePaint);
  }

  @override
  bool shouldRepaint(GridPainter oldDelegate) {
    if (this.balance == oldDelegate.balance && this.fader == oldDelegate.fader)
      return false;
    return true;
  }
}
