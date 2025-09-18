import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:xiangyue/bluetooth/bluetooth_channel.dart';
import 'package:xiangyue/bluetooth/data_pack.dart';
import 'package:xiangyue/utils/screen_util.dart';
import 'package:xiangyue/widgets/custom/div_custom.dart';
import 'package:xiangyue/widgets/custom/image_custom.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  int pressedButton = -1; //状态：目前哪个按钮被按下
  int pressTick = 0;
  Timer tPressed = null;
  @override
  void initState() {
    super.initState();
  }

  void dispose() {
    super.dispose();
  }

  Widget _buildPlayer() {
    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        Positioned(
            //背景圆
            top: getSize(40),
            left: 0,
            right: 0,
            child: ImageCustom(
              name: "bg_yuanpan",
              width: 375,
              boxFit: BoxFit.fitWidth,
            )),
        Positioned(
            //背景圆
            top: getSize(67),
            left: 0,
            right: 0,
            child: ImageCustom(
              name: this.pressedButton == 5
                  ? "h_center"
                  : this.pressedButton == 4
                      ? "h_right"
                      : this.pressedButton == 3
                          ? "h_left"
                          : this.pressedButton == 2
                              ? "h_down"
                              : this.pressedButton == 1
                                  ? "h_up"
                                  : "h",
              width: 300,
              boxFit: BoxFit.fitWidth,
            )),
        // Positioned(
        //     //中心圆
        //     top: getSize(153),
        //     left: getSize(117.5),
        //     child: ImageCustom(
        //       name: this.pressedButton == 5 ? "k_zhong_1" : "k_zhong",
        //       width: 140,
        //       boxFit: BoxFit.fitWidth,
        //     )),
        // Positioned(
        //     //左边按钮
        //     top: getSize(127),
        //     left: getSize(41),
        //     child: ImageCustom(
        //       name: this.pressedButton == 3 ? "k_zuo_1" : "k_zuo",
        //       height: 195,
        //       boxFit: BoxFit.fitHeight,
        //     )),
        // Positioned(
        //     //右边按钮
        //     top: getSize(128),
        //     right: getSize(47),
        //     child: ImageCustom(
        //       name: this.pressedButton == 4 ? "k_you_1" : "k_you",
        //       height: 195,
        //       boxFit: BoxFit.fitHeight,
        //     )),
        // Positioned(
        //     //上边按钮
        //     top: getSize(83),
        //     child: ImageCustom(
        //       name: this.pressedButton == 1 ? "k_shang_1" : "k_shang",
        //       width: 195,
        //       boxFit: BoxFit.fitWidth,
        //     )),
        // Positioned(
        //     //下边按钮
        //     top: getSize(272),
        //     child: ImageCustom(
        //       name: this.pressedButton == 2 ? "k_xia_1" : "k_xia",
        //       width: 195,
        //       boxFit: BoxFit.fitWidth,
        //     )),
        Positioned(
          //中间文字
          top: getSize(175),
          child: GestureDetector(
              onTapDown: (e) {
                if (this.pressedButton != -1) {
                  return;
                }
                this.pressedButton = 5;
                setState(() {});
                DataPack dp = DataPack.initModeControlData();
                dp.data[1] = 0;
                RFCommChannel.requestChannel(dp);
              },
              onTapUp: (e) {
                // 发送source指令
                if (this.pressedButton != 5) return;
                DataPack dp = DataPack.initModeControlData();
                dp.data[1] = 0x02;
                RFCommChannel.requestChannel(dp);
                Future.delayed(Duration(milliseconds: 100), () {
                  this.pressedButton = -1;
                  setState(() {});
                });
              },
              onTapCancel: () {
                if (this.pressedButton != 5) return;
                DataPack dp = DataPack.initModeControlData();
                dp.data[1] = 0x02;
                RFCommChannel.requestChannel(dp);
                Future.delayed(Duration(milliseconds: 100), () {
                  this.pressedButton = -1;
                  setState(() {});
                });
              },
              child: DivCustom(width: 100, height: 100, child: null)),
        ),
        Positioned(
          //上边图标
          top: getSize(100),
          child: GestureDetector(
            onTapDown: (e) {
              print("tap down:" + e.toString());
              if (this.pressedButton != -1) {
                return;
              }
              if (this.tPressed != null) {
                this.tPressed.cancel();
                this.tPressed = null;
              }
              this.pressedButton = 1;
              this.pressTick++;
              if (this.pressTick > 10000) {
                this.pressTick = 0;
              }
              int _tickFlag = this.pressTick;
              // 发送按下指令
              DataPack dp = DataPack.initVolumnControlData();
              dp.data[0] = 0x14;
              dp.data[1] = 0;
              RFCommChannel.requestChannel(dp);
              // 启动定时任务，每500毫秒发送一次按住指令
              Future.delayed(Duration(milliseconds: 500), () {
                if (this.pressedButton != 1 || this.pressTick != _tickFlag) {
                  return;
                }
                DataPack dp = DataPack.initVolumnControlData();
                dp.data[0] = 0x14;
                dp.data[1] = 0x01;
                RFCommChannel.requestChannel(dp);
                if (this.tPressed != null) {
                  this.tPressed.cancel();
                  this.tPressed = null;
                }
                this.tPressed =
                    Timer.periodic(Duration(milliseconds: 100), (timer) {
                  if (this.pressedButton != 1 || this.pressTick != _tickFlag)
                    return;
                  print("timer 0x14  ");
                  DataPack dp = DataPack.initVolumnControlData();
                  dp.data[0] = 0x14;
                  dp.data[1] = 0x01;
                  RFCommChannel.requestChannel(dp);
                });
              });

              setState(() {});
            },
            onTapUp: (e) {
              print("tap up:" + e.toString());
              if (this.pressedButton != 1) {
                return;
              }
              if (this.tPressed != null) {
                this.tPressed.cancel();
                this.tPressed = null;
              }
              Future.delayed(Duration(milliseconds: 100), () {
                DataPack dp = DataPack.initVolumnControlData();
                dp.data[0] = 0x14;
                dp.data[1] = 0x02;
                RFCommChannel.requestChannel(dp);
                this.pressedButton = -1;
                setState(() {});
              });
            },
            onTapCancel: () {
              print("tap cancel");
              if (this.pressedButton != 1) {
                return;
              }
              if (this.tPressed != null) {
                this.tPressed.cancel();
                this.tPressed = null;
              }
              DataPack dp = DataPack.initVolumnControlData();
              dp.data[0] = 0x14;
              dp.data[1] = 0x02;
              RFCommChannel.requestChannel(dp);
              this.pressedButton = -1;
              setState(() {});
            },
            child: DivCustom(width: 140, height: 60, child: null
                // child: ImageCustom(
                //   padding: [0, 0, 14, 0],
                //   name: this.pressedButton == 1 ? "icon_shang_1" : "icon_shang",
                //   width: 42,
                //   boxFit: BoxFit.fitWidth,
                // ),
                ),
          ),
        ),
        Positioned(
            //下边图标
            top: getSize(300),
            child: GestureDetector(
                onTapDown: (e) {
                  print("tap down:" + e.toString());
                  if (this.pressedButton != -1) {
                    return;
                  }
                  if (this.tPressed != null) {
                    this.tPressed.cancel();
                    this.tPressed = null;
                  }
                  this.pressedButton = 2;
                  this.pressTick++;
                  if (this.pressTick > 10000) {
                    this.pressTick = 0;
                  }
                  int _tickFlag = this.pressTick;
                  // 发送按下指令
                  DataPack dp = DataPack.initVolumnControlData();
                  dp.data[0] = 0x15;
                  dp.data[1] = 0;
                  RFCommChannel.requestChannel(dp);
                  Future.delayed(Duration(milliseconds: 500), () {
                    if (this.pressedButton != 2 ||
                        this.pressTick != _tickFlag) {
                      return;
                    }
                    DataPack dp = DataPack.initVolumnControlData();
                    dp.data[0] = 0x15;
                    dp.data[1] = 0x01;
                    RFCommChannel.requestChannel(dp);
                    // 启动定时任务，每500毫秒发送一次按住指令
                    if (this.tPressed != null) {
                      this.tPressed.cancel();
                      this.tPressed = null;
                    }
                    this.tPressed =
                        Timer.periodic(Duration(milliseconds: 100), (timer) {
                      if (this.pressedButton != 2 ||
                          this.pressTick != _tickFlag) return;
                      print("timer 0x15");
                      DataPack dp = DataPack.initVolumnControlData();
                      dp.data[0] = 0x15;
                      dp.data[1] = 0x01;
                      RFCommChannel.requestChannel(dp);
                    });
                  });
                  setState(() {});
                },
                onTapUp: (e) {
                  print("tap up:" + e.toString());
                  if (this.pressedButton != 2) {
                    return;
                  }
                  if (this.tPressed != null) {
                    this.tPressed.cancel();
                    this.tPressed = null;
                  }
                  Future.delayed(Duration(milliseconds: 100), () {
                    DataPack dp = DataPack.initVolumnControlData();
                    dp.data[0] = 0x15;
                    dp.data[1] = 0x02;
                    RFCommChannel.requestChannel(dp);
                    this.pressedButton = -1;
                    setState(() {});
                  });
                },
                onTapCancel: () {
                  print("tap cancel");
                  if (this.pressedButton != 2) {
                    return;
                  }
                  if (this.tPressed != null) {
                    this.tPressed.cancel();
                    this.tPressed = null;
                  }
                  DataPack dp = DataPack.initVolumnControlData();
                  dp.data[0] = 0x15;
                  dp.data[1] = 0x02;
                  RFCommChannel.requestChannel(dp);
                  this.pressedButton = -1;
                  setState(() {});
                },
                child: DivCustom(
                    width: 140, height: 60, padding: [10, 0, 0, 0], child: null
                    // child: ImageCustom(
                    //   padding: [0, 0, 19, 0],
                    //   name: this.pressedButton == 2 ? "icon_xia_1" : "icon_xia",
                    //   width: 42,
                    //   boxFit: BoxFit.fitWidth,
                    // )
                    ))),
        Positioned(
            //左边图标
            top: getSize(150),
            left: getSize(55),
            child: GestureDetector(
                onTapDown: (e) {
                  print("tap down:" + e.toString());
                  if (this.pressedButton != -1) {
                    return;
                  }
                  if (this.tPressed != null) {
                    this.tPressed.cancel();
                    this.tPressed = null;
                  }
                  this.pressedButton = 3;
                  this.pressTick++;
                  if (this.pressTick > 10000) {
                    this.pressTick = 0;
                  }
                  int _tickFlag = this.pressTick;
                  // 发送按下指令
                  DataPack dp = DataPack.initVolumnControlData();
                  dp.data[0] = 0x13;
                  dp.data[1] = 0;
                  RFCommChannel.requestChannel(dp);
                  Future.delayed(Duration(milliseconds: 500), () {
                    if (this.pressedButton != 3 ||
                        this.pressTick != _tickFlag) {
                      return;
                    }
                    DataPack dp = DataPack.initVolumnControlData();
                    dp.data[0] = 0x13;
                    dp.data[1] = 0x01;
                    RFCommChannel.requestChannel(dp);
                    // 启动定时任务，每500毫秒发送一次按住指令
                    if (this.tPressed != null) {
                      this.tPressed.cancel();
                      this.tPressed = null;
                    }
                    this.tPressed =
                        Timer.periodic(Duration(milliseconds: 100), (timer) {
                      if (this.pressedButton != 3 ||
                          this.pressTick != _tickFlag) return;
                      print("timer 0x13");
                      DataPack dp = DataPack.initVolumnControlData();
                      dp.data[0] = 0x13;
                      dp.data[1] = 0x01;
                      RFCommChannel.requestChannel(dp);
                    });
                  });
                  setState(() {});
                },
                onTapUp: (e) {
                  print("tap up:" + e.toString());
                  if (this.pressedButton != 3) {
                    return;
                  }
                  if (this.tPressed != null) {
                    this.tPressed.cancel();
                    this.tPressed = null;
                  }
                  Future.delayed(Duration(milliseconds: 100), () {
                    DataPack dp = DataPack.initVolumnControlData();
                    dp.data[0] = 0x13;
                    dp.data[1] = 0x02;
                    RFCommChannel.requestChannel(dp);
                    this.pressedButton = -1;
                    setState(() {});
                  });
                },
                onTapCancel: () {
                  print("tap cancel");
                  if (this.pressedButton != 3) {
                    return;
                  }
                  if (this.tPressed != null) {
                    this.tPressed.cancel();
                    this.tPressed = null;
                  }
                  DataPack dp = DataPack.initVolumnControlData();
                  dp.data[0] = 0x13;
                  dp.data[1] = 0x02;
                  RFCommChannel.requestChannel(dp);
                  this.pressedButton = -1;
                  setState(() {});
                },
                child: DivCustom(height: 140, width: 60, child: null
                    // child: ImageCustom(
                    //   padding: [0, 0, 0, 0],
                    //   name: this.pressedButton == 3 ? "icon_zuo_1" : "icon_zuo",
                    //   width: 42,
                    //   boxFit: BoxFit.fitWidth,
                    // )
                    ))),
        Positioned(
            //右边图标
            top: getSize(150),
            right: getSize(55),
            child: GestureDetector(
                onTapDown: (e) {
                  print("tap down:" + e.toString());
                  if (this.pressedButton != -1) {
                    return;
                  }
                  if (this.tPressed != null) {
                    this.tPressed.cancel();
                    this.tPressed = null;
                  }
                  this.pressedButton = 4;
                  this.pressTick++;
                  if (this.pressTick > 10000) {
                    this.pressTick = 0;
                  }
                  int _tickFlag = this.pressTick;
                  // 发送按下指令
                  DataPack dp = DataPack.initVolumnControlData();
                  dp.data[0] = 0x12;
                  dp.data[1] = 0;
                  RFCommChannel.requestChannel(dp);
                  Future.delayed(Duration(milliseconds: 500), () {
                    if (this.pressedButton != 4 ||
                        this.pressTick != _tickFlag) {
                      return;
                    }
                    DataPack dp = DataPack.initVolumnControlData();
                    dp.data[0] = 0x12;
                    dp.data[1] = 0x01;
                    RFCommChannel.requestChannel(dp);
                    // 启动定时任务，每500毫秒发送一次按住指令
                    if (this.tPressed != null) {
                      this.tPressed.cancel();
                      this.tPressed = null;
                    }
                    this.tPressed =
                        Timer.periodic(Duration(milliseconds: 100), (timer) {
                      if (this.pressedButton != 4 ||
                          this.pressTick != _tickFlag) return;
                      print("timer 0x12");
                      DataPack dp = DataPack.initVolumnControlData();
                      dp.data[0] = 0x12;
                      dp.data[1] = 0x01;
                      RFCommChannel.requestChannel(dp);
                    });
                  });
                  setState(() {});
                },
                onTapUp: (e) {
                  print("tap up:" + e.toString());
                  if (this.pressedButton != 4) {
                    return;
                  }
                  if (this.tPressed != null) {
                    this.tPressed.cancel();
                    this.tPressed = null;
                  }
                  Future.delayed(Duration(milliseconds: 100), () {
                    DataPack dp = DataPack.initVolumnControlData();
                    dp.data[0] = 0x12;
                    dp.data[1] = 0x02;
                    RFCommChannel.requestChannel(dp);
                    this.pressedButton = -1;
                    setState(() {});
                  });
                },
                onTapCancel: () {
                  print("tap cancel");
                  if (this.pressedButton != 4) {
                    return;
                  }
                  if (this.tPressed != null) {
                    this.tPressed.cancel();
                    this.tPressed = null;
                  }
                  DataPack dp = DataPack.initVolumnControlData();
                  dp.data[0] = 0x12;
                  dp.data[1] = 0x02;
                  RFCommChannel.requestChannel(dp);
                  this.pressedButton = -1;
                  setState(() {});
                },
                child: DivCustom(width: 60, height: 140, child: null
                    // child: ImageCustom(
                    //   padding: [0, 0, 0, 0],
                    //   name: this.pressedButton == 4 ? "icon_you_1" : "icon_you",
                    //   width: 42,
                    //   boxFit: BoxFit.fitWidth,
                    // )
                    ))),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0x00000000),
      body: DivCustom(margin: [30, 0, 0, 0], child: _buildPlayer()),
    );
  }
}
