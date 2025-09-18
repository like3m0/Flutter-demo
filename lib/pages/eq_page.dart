import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:xiangyue/bluetooth/audio_status.dart';
import 'package:xiangyue/bluetooth/bluetooth_channel.dart';
import 'package:xiangyue/bluetooth/data_pack.dart';
import 'package:xiangyue/utils/pop_dialog.dart';
import 'package:xiangyue/utils/screen_util.dart';
import 'package:xiangyue/widgets/custom/div_custom.dart';
import 'package:xiangyue/widgets/custom/image_custom.dart';
import 'package:xiangyue/widgets/custom/text_custom.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
import 'package:provider/provider.dart';
import 'package:flustars/flustars.dart';

class EQPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _EQPageState();
  }
}

class _EQPageState extends State<EQPage> {
  int selectedCustomIndex = -1;
  List<int> currentFreq = [0, 0, 0, 0, 0, 0, 0, 0, 0];

  Timer tDragging = null;
  Color barColor;
  bool showHandler = false;
  int pressedButtonIndex = -1;

  AudioStatus au = null;
  bool freqInited = false;

  @override
  void initState() {
    super.initState();
    this.au = Provider.of<AudioStatus>(context, listen: false);
    if (au.EQIndex == 6) {
      for (var i = 0; i < 9; i++) {
        this.currentFreq[i] = au.freqCustom1[i] - 12;
      }
    } else if (au.EQIndex == 7) {
      for (var i = 0; i < 9; i++) {
        this.currentFreq[i] = au.freqCustom2[i] - 12;
      }
    }
  }

  void dispose() {
    super.dispose();
  }

  Widget _buildAScrollBar(int index, AudioStatus auNow, double heightLimit) {
    var keduPT = 40 * heightLimit / 323;
    var keduHeight = 250 * heightLimit / 323;
    return Positioned(
        top: 0,
        left: getSize(index.toDouble() * 30 - 12),
        bottom: 0,
        child: DivCustom(
            margin: [0, 0, 0, 10],
            width: 32,
            child: Stack(children: [
              DivCustom(
                width: 32,
                height: keduHeight - 20,
                margin: [keduPT + 10, 0, 10, 0],
                child: ImageCustom(
                  padding: [0, 0, 0, 0],
                  name: "k_shujutiao_kedu",
                  width: 8,
                  height: keduHeight - 20,
                  boxFit: BoxFit.fill,
                ),
              ),
              DivCustom(
                margin: [keduPT, 0, 0, 0],
                child: auNow.EQIndex < 6
                    ? null
                    : FlutterSlider(
                        min: -12,
                        max: 12,
                        axis: Axis.vertical,
                        rtl: true,
                        values: [this.currentFreq[index].toDouble()],
                        selectByTap: false,
                        step: FlutterSliderStep(step: 1),
                        centeredOrigin: true,
                        trackBar: FlutterSliderTrackBar(
                          inactiveTrackBarHeight: getSize(3),
                          activeTrackBarHeight: getSize(3),
                          activeTrackBar: BoxDecoration(
                            color: this.selectedCustomIndex == index
                                ? Color(0xFFFF5E21)
                                : this.barColor,
                          ),
                          inactiveTrackBar:
                              BoxDecoration(color: Colors.transparent),
                        ),
                        hatchMark: FlutterSliderHatchMark(
                          disabled: false,
                          density: 1,
                          displayLines: true,
                          linesDistanceFromTrackBar: 1,
                          smallLine: FlutterSliderSizedBox(
                              height: 1,
                              width: 5,
                              decoration:
                                  BoxDecoration(color: Color(0xFF888888))),
                          linesAlignment: FlutterSliderHatchMarkAlignment.left,
                        ),
                        handler: showHandler
                            ? FlutterSliderHandler(
                                decoration:
                                    BoxDecoration(color: Colors.transparent),
                                child: ImageCustom(
                                    padding: [0, 0, 0, 0],
                                    name: this.selectedCustomIndex == index
                                        ? "eq_scroll_1"
                                        : "eq_scorll",
                                    width: 19,
                                    boxFit: BoxFit.fitWidth))
                            : FlutterSliderHandler(
                                decoration:
                                    BoxDecoration(color: Colors.transparent),
                                child: DivCustom(
                                  padding: [0, 0, 0, 0],
                                  width: 19,
                                )),
                        tooltip: FlutterSliderTooltip(
                            textStyle:
                                TextStyle(fontSize: 20, color: Colors.grey),
                            boxStyle: FlutterSliderTooltipBox(
                                decoration:
                                    BoxDecoration(color: Colors.white))),
                        onDragStarted: (handlerIndex, lowerValue, upperValue) {
                          if (index != this.selectedCustomIndex) {
                            this.selectedCustomIndex = index;
                            this.currentFreq[index] = lowerValue.round();
                            if (this.tDragging != null) {
                              this.tDragging.cancel();
                              this.tDragging = null;
                            }
                            if (this.tDragging == null) {
                              this.tDragging = Timer.periodic(
                                  Duration(milliseconds: 500), (timer) {
                                DataPack dp = DataPack.initTuneCustomData();
                                for (int i = 0;
                                    i < this.currentFreq.length;
                                    i++) {
                                  dp.data[i] = this.currentFreq[i] + 12;
                                }
                                RFCommChannel.requestChannelSilent(dp);
                              });
                            }
                          }
                        },
                        onDragging: (handlerIndex, lowerValue, upperValue) {
                          this.currentFreq[index] = lowerValue.round();
                          setState(() {});
                        },
                        onDragCompleted:
                            (handlerIndex, lowerValue, upperValue) {
                          if (this.tDragging != null) {
                            tDragging.cancel();
                            tDragging = null;
                          }
                          this.currentFreq[index] = lowerValue.round();
                          DataPack dp = DataPack.initTuneCustomData();
                          for (int i = 0; i < this.currentFreq.length; i++) {
                            dp.data[i] = this.currentFreq[i] + 12;
                          }
                          RFCommChannel.requestChannel(dp);
                          this.selectedCustomIndex = -1;
                          setState(() {});
                        }),
              ),
              TextCustom(
                margin: [10, 0, (300 - 55) * heightLimit / 323, 0],
                text: auNow.EQIndex > 5 ? "${this.currentFreq[index]}" : "0",
                size: index != this.selectedCustomIndex ? 10 : 12,
                color: index != this.selectedCustomIndex
                    ? "0xFF888888"
                    : "0xFFFF5E21",
              ),
            ])));
  }

  void saveCustom(int index) {
    if (pressedButtonIndex != index) {
      return;
    }
    this.pressedButtonIndex = -1;
    if (index < 6) {
      return;
    }
    int whichCustom = 0;
    if (index == 7) {
      whichCustom = 1;
    }
    //保存自定义频率
    DataPack dp = DataPack.initSaveCustomData(whichCustom);
    for (int i = 0; i < this.currentFreq.length; i++) {
      dp.data[i + 1] = this.currentFreq[i] + 12;
    }
    RFCommChannel.requestChannel(dp);
    var saveFreq = [0, 0, 0, 0, 0, 0, 0, 0, 0];
    for (var i = 0; i < 9; i++) {
      saveFreq[i] = this.currentFreq[i] + 12;
    }
    this.au.setCustomFreq(whichCustom, saveFreq);
    showNotifyDialog(context, "Custom data is saved.");
  }

  Widget _buildEQButton(
      int index, String name, String choosedName, AudioStatus auNow) {
    return GestureDetector(
      onTapDown: (e) {
        if (this.tDragging != null) {
          this.tDragging.cancel();
          this.tDragging = null;
        }
        if (index == auNow.EQIndex) {
          if (index >= 6) {
            this.pressedButtonIndex = index;
            Future.delayed(Duration(seconds: 3), () {
              //长击3秒，保存customfreq
              saveCustom(index);
            });
          }
          return;
        }
        this.selectedCustomIndex = -1;
        this.currentFreq = [0, 0, 0, 0, 0, 0, 0, 0, 0];
        this.freqInited = false;
        if (index == 6) {
          for (var i = 0; i < 9; i++) {
            this.currentFreq[i] = auNow.freqCustom1[i] - 12;
            this.freqInited = true;
          }
        } else if (index == 7) {
          for (var i = 0; i < 9; i++) {
            this.currentFreq[i] = auNow.freqCustom2[i] - 12;
            this.freqInited = true;
          }
        }
        DataPack dp = DataPack.initEQData(index);
        RFCommChannel.requestChannel(dp);
        this.au.setEQ(index);
        this.barColor = Color(0x00000000);
        this.showHandler = false;
        if (index >= 6) {
          Future.delayed(Duration(milliseconds: 50), () {
            this.barColor = Color(0xFF0B90D9);
            this.showHandler = true;
            setState(() {});
          });
        }
      },
      onTapUp: (e) {
        this.pressedButtonIndex = -1;
      },
      onTapCancel: () {
        this.pressedButtonIndex = -1;
      },
      child: DivCustom(
        margin: [0, 0, 0, 0],
        child: ImageCustom(
          name: auNow.EQIndex == index ? choosedName : name,
          width: 80,
          boxFit: BoxFit.fitWidth,
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext ctx) {
    var height = ScreenUtil.getScreenH(ctx);
    var appBarHeight = ScreenUtil.getStatusBarH(ctx);
    var statusHeight = ScreenUtil.getStatusBarH(ctx);
    var usableHeight = (height - appBarHeight - statusHeight) /
        ScreenUtil.getInstance().getRatio();
    usableHeight = usableHeight - 355;
    usableHeight -= 30;
    // usableHeight -= 180;
    // usableHeight -= 62;
    if (usableHeight >= 323) {
      usableHeight = 323;
    }
    // usableHeight = 255;

    return Consumer<AudioStatus>(
        builder: (BuildContext context, AudioStatus audioStatus, Widget child) {
      if (audioStatus.EQIndex >= 6) {
        // 择中custom1或者custom2
        if (this.freqInited == false) {
          //没有初始化（不是按钮过来的）
          if (audioStatus.EQIndex == 6) {
            for (var i = 0; i < 9; i++) {
              this.currentFreq[i] = audioStatus.freqCustom1[i] - 12;
              this.freqInited = true;
            }
          } else if (audioStatus.EQIndex == 7) {
            for (var i = 0; i < 9; i++) {
              this.currentFreq[i] = audioStatus.freqCustom2[i] - 12;
              this.freqInited = true;
            }
          }
          this.barColor = Color(0x00000000);
          this.showHandler = false;
          Future.delayed(Duration(milliseconds: 50), () {
            this.barColor = Color(0xFF0B90D9);
            this.showHandler = true;
            setState(() {});
          });
        }
      }
      return Column(mainAxisAlignment: MainAxisAlignment.start, children: [
        DivCustom(
            margin: [0, 0, 0, 0],
            child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              DivCustom(
                width: 100,
                child: TextCustom(
                    padding: [0, 0, 15, 30],
                    text: "Preset",
                    size: 14,
                    color: "#ffffffff"),
              ),
              _buildEQButton(0, "btn_flat", "btn_flat_0", audioStatus),
              _buildEQButton(1, "btn_classic", "btn_classic_0", audioStatus),
              _buildEQButton(2, "btn_jazz", "btn_jazz_0", audioStatus),
            ])),
        DivCustom(
            margin: [0, 0, 0, 0],
            child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              DivCustom(
                width: 100,
              ),
              _buildEQButton(3, "btn_pop", "btn_pop_0", audioStatus),
              _buildEQButton(4, "btn_rock", "btn_rock_0", audioStatus),
              _buildEQButton(5, "btn_beat", "btn_beat_0", audioStatus),
            ])),
        DivCustom(
          margin: [2, 35, 5, 30],
          height: 1,
          color: "0xFFA9AAAB",
        ),
        DivCustom(
            margin: [0, 0, 0, 0],
            child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              DivCustom(
                width: 100,
                child: TextCustom(
                    padding: [0, 0, 15, 30],
                    text: "Custom",
                    size: 14,
                    color: "#ffffffff"),
              ),
              _buildEQButton(6, "btn_custom1", "btn_custom1_0", audioStatus),
              _buildEQButton(7, "btn_custom2", "btn_custom2_0", audioStatus),
            ])),
        DivCustom(
            margin: [5, 0, 0, 0],
            width: 375,
            child: Stack(
              children: [
                DivCustom(
                    width: 375,
                    height: usableHeight,
                    child: ImageCustom(
                        name: "eq_bg",
                        width: 375,
                        height: usableHeight,
                        boxFit: BoxFit.fill)),
                Positioned(
                    top: 5 * usableHeight / 323,
                    left: getSize(55),
                    right: getSize(55),
                    height: 300 * usableHeight / 323,
                    child: DivCustom(
                        margin: [0, 0, 0, 0],
                        // color: "0x55ffffff",
                        child: Stack(
                          children: [
                            _buildAScrollBar(0, audioStatus, usableHeight),
                            _buildAScrollBar(1, audioStatus, usableHeight),
                            _buildAScrollBar(2, audioStatus, usableHeight),
                            _buildAScrollBar(3, audioStatus, usableHeight),
                            _buildAScrollBar(4, audioStatus, usableHeight),
                            _buildAScrollBar(5, audioStatus, usableHeight),
                            _buildAScrollBar(6, audioStatus, usableHeight),
                            _buildAScrollBar(7, audioStatus, usableHeight),
                            _buildAScrollBar(8, audioStatus, usableHeight),
                          ],
                        ))),
              ],
            )),
        DivCustom(
          margin: [0, 0, 0, 0],
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              TextCustom(
                  margin: [0, 0, 0, 27],
                  padding: [0, 0, 0, 0],
                  text: "Hz/",
                  color: "0xffaaaaaa",
                  size: 12),
              TextCustom(
                  margin: [0, 0, 0, 13],
                  padding: [10, 0, 0, 0],
                  text: "63",
                  color: "0xff888888",
                  size: 12),
              TextCustom(
                  margin: [0, 0, 0, 12],
                  padding: [10, 0, 0, 0],
                  text: "125",
                  color: "0xff888888",
                  size: 12),
              TextCustom(
                  margin: [0, 0, 0, 9],
                  padding: [10, 0, 0, 0],
                  text: "250",
                  color: "0xff888888",
                  size: 12),
              TextCustom(
                  margin: [0, 0, 0, 10],
                  padding: [10, 0, 0, 0],
                  text: "500",
                  color: "0xff888888",
                  size: 12),
              TextCustom(
                  margin: [0, 0, 0, 14],
                  padding: [10, 0, 0, 0],
                  text: "1k",
                  color: "0xff888888",
                  size: 12),
              TextCustom(
                  margin: [0, 0, 0, 17],
                  padding: [10, 0, 0, 0],
                  text: "2k",
                  color: "0xff888888",
                  size: 12),
              TextCustom(
                  margin: [0, 0, 0, 20],
                  padding: [10, 0, 0, 0],
                  text: "4k",
                  color: "0xff888888",
                  size: 12),
              TextCustom(
                  margin: [0, 0, 0, 18],
                  padding: [10, 0, 0, 0],
                  text: "8k",
                  color: "0xff888888",
                  size: 12),
              TextCustom(
                  margin: [0, 0, 0, 15],
                  padding: [10, 0, 0, 0],
                  text: "16k",
                  color: "0xff888888",
                  size: 12),
            ],
          ),
        ),
      ]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0x00000000),
      body: DivCustom(margin: [10, 0, 0, 0], child: _buildBody(context)),
    );
  }
}
