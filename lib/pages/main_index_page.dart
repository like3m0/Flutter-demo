import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:xiangyue/bluetooth/audio_status.dart';
import 'package:xiangyue/bluetooth/bluetooth_channel.dart';
import 'package:xiangyue/bluetooth/data_pack.dart';
import 'package:xiangyue/model/theme_setting.dart';
import 'package:xiangyue/pages/about_page.dart';
import 'package:xiangyue/pages/balance_page.dart';
import 'package:xiangyue/pages/home_page.dart';
import 'package:xiangyue/pages/eq_page.dart';
import 'package:xiangyue/pages/help_page.dart';
import 'package:xiangyue/pages/policy_page.dart';
import 'package:xiangyue/pages/setting_page.dart';
import 'package:xiangyue/utils/toast_util.dart';
import 'package:xiangyue/widgets/custom/div_custom.dart';
import 'package:xiangyue/widgets/custom/image_custom.dart';
import 'package:xiangyue/widgets/custom/text_custom.dart';
import 'package:provider/provider.dart';
import 'package:app_settings/app_settings.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:xiangyue/utils/screen_util.dart';
import 'package:flustars/flustars.dart';
import 'package:xiangyue/utils/pop_dialog.dart';
import 'package:permission_handler/permission_handler.dart';

class MainIndexPage extends StatefulWidget {
  MainIndexPage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  MainIndexPageState createState() => MainIndexPageState();
}

//四种背景色
const arrTitle = [
  "Home",
  "Basic Sound",
  "Equalizer",
  '''DA Remote 2
  Background Color'''
];

class MainIndexPageState extends State<MainIndexPage>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  int currentPageIndex = 0;
  bool bConnected = true;
  bool bDisplayMenu = false;
  double _dx = 0;
  double _dy = 0;
  String title = arrTitle[0];
  int menuClicked = -1;

  void checkPermission() async {
    var status = await Permission.bluetooth.status;
    if (status.isDenied) {
      requestPermission();
    }
  }

  void requestPermission() async {
    // var isLocationGranted = await Permission.locationWhenInUse.request();
    // print('checkBlePermissions, isLocationGranted=$isLocationGranted');

    // var isBleGranted = await Permission.bluetooth.request();
    // print('checkBlePermissions, isBleGranted=$isBleGranted');

    // var isBleScanGranted = await Permission.bluetoothScan.request();
    // print('checkBlePermissions, isBleScanGranted=$isBleScanGranted');
    // //
    // var isBleConnectGranted = await Permission.bluetoothConnect.request();
    // print('checkBlePermissions, isBleConnectGranted=$isBleConnectGranted');
    // //
    // var isBleAdvertiseGranted = await Permission.bluetoothAdvertise.request();
    // print('checkBlePermissions, isBleAdvertiseGranted=$isBleAdvertiseGranted');
    List<Permission> l = [];
    l.add(Permission.locationWhenInUse);
    l.add(Permission.bluetooth);
    l.add(Permission.bluetoothScan);
    l.add(Permission.bluetoothConnect);
    l.add(Permission.bluetoothAdvertise);
    var pstatus = await l.request();
    print('permission status:' + pstatus.toString());
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // checkPermission();
    // DataPack dp = DataPack.enterSound();
    // RFCommChannel.requestChannel(dp);
    Timer.periodic(Duration(seconds: 2), (timer) {
      this.checkConnection();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.resumed:
        if (this.currentPageIndex == 1 || this.currentPageIndex == 2) {
          DataPack dp = DataPack.enterSound();
          RFCommChannel.requestChannel(dp);
        }
        break;
      case AppLifecycleState.paused:
        if (this.currentPageIndex == 1 || this.currentPageIndex == 2) {
          DataPack dp = DataPack.exitSound();
          RFCommChannel.requestChannel(dp);
        }
        break;
      case AppLifecycleState.detached:
        if (this.currentPageIndex == 1 || this.currentPageIndex == 2) {
          DataPack dp = DataPack.exitSound();
          RFCommChannel.requestChannel(dp);
        }
        break;
      case AppLifecycleState.hidden: // 👈 新增的枚举值
      // 你可以按需要处理，或者留空
        break;
    }
  }

  // 检查并请求Android系统用户存储卡授权
  void checkConnection() async {
    print("before listen, checkPermission now --------");
    checkPermission();
    print("checkConnection in mainindex, try to listen..........");
    AudioStatus as = Provider.of<AudioStatus>(context, listen: false);
    if (!as.connected) {
      as.listen();
    }
  }

  int _lastClickTime = 0;

  Future<bool> _doubleExit() {
    // if (currentPageIndex != 0) {
    //   return new Future.value(false);
    // }
    int nowTime = new DateTime.now().microsecondsSinceEpoch;
    if (_lastClickTime != 0 && nowTime - _lastClickTime > 1500) {
      exit(0);
    } else {
      ToastUtil.toast("再按一次退出程序");
      _lastClickTime = new DateTime.now().microsecondsSinceEpoch;
      new Future.delayed(const Duration(milliseconds: 1500), () {
        _lastClickTime = 0;
      });
      return new Future.value(false);
    }
  }

  void setCurrentPageIndex(int index) {
    DataPack? dp;
    if ((this.currentPageIndex == 0 || this.currentPageIndex == 3) &&
        (index == 1 || index == 2)) {
      dp = DataPack.enterSound();
    } else if ((this.currentPageIndex == 1 || this.currentPageIndex == 2) &&
        (index != 1) &&
        (index != 2)) {
      dp = DataPack.exitSound();
    }
    this.currentPageIndex = index;
    this.title = arrTitle[index];
    this.setState(() {});
    if (dp != null) {
      RFCommChannel.requestChannel(dp);
    }
  }

  @override
  Widget build(BuildContext context) {
    // print("build() called!!!!!!!!!!!!");
    // this.checkConnection();
    var h = ScreenUtil.getScreenH(context);
    var w = ScreenUtil.getScreenW(context);
    var bottom_margin = 35;
    if (w / h > 0.52) {
      bottom_margin = 20;
    }
    return WillPopScope(
      onWillPop: _doubleExit,
      child: Scaffold(
        backgroundColor: Provider.of<ThemeSettings>(context, listen: true)
            .getBackgroundColor(),
        body: Stack(
          alignment: AlignmentDirectional.center,
          children: [
            Positioned(
              //上方控制条
              top: 0,
              left: 0,
              right: 0,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                      onTap: () {
                        print("tap 菜单");
                        this.bDisplayMenu = !this.bDisplayMenu;
                        if (!this.bDisplayMenu) {
                          this.menuClicked = -1;
                        }
                        setState(() {});
                      },
                      child: DivCustom(
                          padding: [
                            MediaQuery.of(context).padding.top,
                            0,
                            0,
                            13.5
                          ],
                          width: 73.5,
                          height: 60 + MediaQuery.of(context).padding.top,
                          child: ImageCustom(
                              imgType: "png",
                              name: this.bDisplayMenu
                                  ? "icon_caidan_2"
                                  : "icon_caidan_1",
                              width: 60,
                              height: 60))),
                  DivCustom(
                    width: 170,
                    height: 60 + MediaQuery.of(context).padding.top,
                  ),
                  DivCustom(
                    width: 50,
                    height: 65 + MediaQuery.of(context).padding.top,
                    child: Provider.of<AudioStatus>(context, listen: true)
                            .connected
                        ? ImageCustom(
                            padding: [35, 0, 0, 0],
                            name: "icon_lianjie",
                            width: 40)
                        : DivCustom(),
                  ),
                  GestureDetector(
                    onTap: () async {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (_, __, ___) => AboutPage(),
                          transitionDuration: Duration(seconds: 0),
                        ),
                      );
                    },
                    child: DivCustom(
                        width: 73.5,
                        height: 60 + MediaQuery.of(context).padding.top,
                        padding: [
                          MediaQuery.of(context).padding.top,
                          13.5,
                          0,
                          0
                        ],
                        child: ImageCustom(
                            imgType: "png",
                            name: "icon_xiangqing_1",
                            width: 60,
                            height: 60)),
                  )
                ],
              ),
            ),
            Positioned(
              //拉丝背景图
              top: getSize(65) + MediaQuery.of(context).padding.top,
              left: 0,
              right: 0,
              bottom: 0,
              child: DivCustom(
                  margin: [0, 0, 0, 0],
                  padding: [0, 0, 0, 0],
                  child: ImageCustom(
                    width: 375,
                    height: 1700,
                    name: Provider.of<ThemeSettings>(context, listen: true)
                        .getBackgroundImageName(),
                    boxFit: BoxFit.fill,
                  )),
            ),
            Positioned(
              //页面标题
              top: getSize(80) + MediaQuery.of(context).padding.top,
              left: 0,
              right: 0,
              child: Text(
                this.title,
                textAlign: TextAlign.center,
                textDirection: TextDirection.ltr,
                maxLines: 2,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 21.5,
                    height: 1.3,
                    fontWeight: FontWeight.w500),
              ),
              // child: TextCustom(
              //   text: this.title,
              //   maxLines: 2,
              //   color: "#ffffffff",
              //   size: 21.5,
              //   weight: FontWeight.w500,
              // )
            ),
            Positioned(
              //页面操作区域，分4个页面，每个页面单独逻辑
              top: getSize(115) + MediaQuery.of(context).padding.top,
              left: 0,
              right: 0,
              bottom: 0,
              child: GestureDetector(
                onPanUpdate: (DragUpdateDetails e) {
                  this._dx += e.delta.dx;
                  this._dy += e.delta.dy;
                },
                onPanCancel: () {
                  this._dx = 0;
                  this._dy = 0;
                },
                onPanEnd: (DragEndDetails e) {
                  print("pan delta x is:${this._dx}");
                  print("pan velocity x:${e.velocity}");
                  if (this._dx > 150 && e.velocity.pixelsPerSecond.dx > 200) {
                    if (this.currentPageIndex > 0) {
                      setCurrentPageIndex(this.currentPageIndex - 1);
                    }
                  }
                  if (this._dx < -150 && e.velocity.pixelsPerSecond.dx < -200) {
                    if (this.currentPageIndex < 3) {
                      setCurrentPageIndex(this.currentPageIndex + 1);
                    }
                  }
                  this._dx = 0;
                  this._dy = 0;
                },
                child: AnimatedSwitcher(
                  duration: Duration(milliseconds: 1200),
                  transitionBuilder: (child, animation) => SizeTransition(
                    sizeFactor: animation,
                    child: IndexedStack(
                      index: this.currentPageIndex,
                      children: [
                        HomePage(),
                        BalancePage(),
                        EQPage(),
                        SettingPage()
                      ],
                    ),
                  ),
                  child: IndexedStack(
                    children: [
                      HomePage(),
                      BalancePage(),
                      EQPage(),
                      SettingPage()
                    ],
                    index: this.currentPageIndex,
                  ),
                ),
              ),
            ),
            Positioned(
                //下方切换用的控制条
                bottom: getSize(bottom_margin.toDouble()),
                left: getSize(22.5),
                right: getSize(22.5),
                child: Stack(
                  children: [
                    ImageCustom(
                        margin: [8, 0, 0, 0],
                        name: "bottom_${this.currentPageIndex}",
                        width: 330,
                        height: 14),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            print("tap 0000");
                            if (this.currentPageIndex != 0)
                              setCurrentPageIndex(0);
                          },
                          child: DivCustom(
                              margin: [0, 0, 0, 9],
                              width: 78,
                              height: 30,
                              child: null
                              // child: this.currentPageIndex == 0
                              //     ? ImageCustom(
                              //         padding: [0, 0, 5, 0],
                              //         width: 80,
                              //         height: 14,
                              //         name: "qiehuan",
                              //         boxFit: BoxFit.fill,
                              //       )
                              //     : null
                              ),
                        ),
                        GestureDetector(
                          onTap: () {
                            print("tap 1111");
                            if (this.currentPageIndex != 1)
                              setCurrentPageIndex(1);
                          },
                          child: DivCustom(
                            margin: [0, 0, 0, 0],
                            width: 78,
                            height: 30,
                            child: null,
                            // child: this.currentPageIndex == 1
                            //     ? ImageCustom(
                            //         padding: [0, 0, 5, 0],
                            //         width: 80,
                            //         height: 14,
                            //         name: "qiehuan_2_1",
                            //         boxFit: BoxFit.fill,
                            //       )
                            //     : null
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            print("tap 2222");
                            if (this.currentPageIndex != 2)
                              setCurrentPageIndex(2);
                          },
                          child: DivCustom(
                              margin: [0, 0, 0, 0],
                              width: 78,
                              height: 30,
                              child: null
                              // child: this.currentPageIndex == 2
                              //     ? ImageCustom(
                              //         padding: [0, 0, 5, 0],
                              //         width: 78,
                              //         height: 14,
                              //         name: "qiehuan_3_1",
                              //         boxFit: BoxFit.fill,
                              //       )
                              //     : null
                              ),
                        ),
                        GestureDetector(
                          onTap: () {
                            print("tap 3333");
                            if (this.currentPageIndex != 3)
                              setCurrentPageIndex(3);
                          },
                          child: DivCustom(
                            margin: [0, 0, 0, 0],
                            width: 78,
                            height: 30,
                            child: null,
                            // child: this.currentPageIndex == 3
                            //     ? ImageCustom(
                            //         padding: [0, 0, 5, 0],
                            //         width: 78,
                            //         height: 14,
                            //         name: "qiehuan_4_1",
                            //         boxFit: BoxFit.fill,
                            //       )
                            //     : null
                          ),
                        ),
                      ],
                    ),
                  ],
                )),
            if (this.bDisplayMenu)
              Positioned(
                  //弹出菜单
                  top: getSize(50) + MediaQuery.of(context).padding.top,
                  left: 0,
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: () {
                      print("pop empty clicked!");
                      this.bDisplayMenu = false;
                      this.menuClicked = -1;
                      setState(() {});
                    },
                    child: Stack(children: [
                      Positioned(
                        top: 0,
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: DivCustom(),
                      ),
                      Positioned(
                        left: getSize(25),
                        top: 0,
                        child:
                            ImageCustom(name: "caidan_bg", width: 224), //菜单背景图
                      ),
                      DivCustom(
                          //定位菜单位置
                          margin: [20, 0, 0, 24],
                          width: 220,
                          height: 552,
                          child: Column(
                            //四行菜单
                            children: [
                              GestureDetector(
                                  onTap: () async {
                                    print("Connection Setting");
                                    this.menuClicked = 0;
                                    setState(() {});

                                    bool? btEnable = await FlutterBluetoothSerial
                                        .instance.isEnabled;
                                    if (Provider.of<AudioStatus>(context,
                                                listen: false)
                                            .connected ==
                                        true) {
                                      showNotifyDialog(context,
                                          "Already Connected to Display Audio.");
                                    }
                                    // else if (btEnable == true) {
                                    //   showNotifyDialog(context,
                                    //       "No device connected. please establish connection with Display Audio.");
                                    // }
                                    else {
                                      AppSettings.openAppSettings();
                                    }
                                  },
                                  child: DivCustom(
                                      padding: [0, 0, 0, 0],
                                      width: 210,
                                      height: 53,
                                      color: this.menuClicked == 0
                                          ? "0xFFBCBCBC"
                                          : "0x00000000",
                                      child: Row(
                                        children: [
                                          ImageCustom(
                                              padding: [4, 0, 0, 15],
                                              name: this.menuClicked == 0
                                                  ? "icon_Connection_1"
                                                  : "icon_Connection",
                                              width: 25),
                                          TextCustom(
                                              padding: [15, 0, 0, 10],
                                              text: "Connection Setting",
                                              size: 16)
                                        ],
                                      ))),
                              DivCustom(
                                color: "0x33FFFFFF",
                                width: 175,
                                height: 1,
                              ),
                              GestureDetector(
                                  onTap: () {
                                    this.menuClicked = 1;
                                    setState(() {});
                                    // Navigator.push(
                                    //     context,
                                    //     MaterialPageRoute(
                                    //         builder: (context) => HelpPage()));
                                    Navigator.push(
                                      context,
                                      PageRouteBuilder(
                                        pageBuilder: (_, __, ___) => HelpPage(),
                                        transitionDuration:
                                            Duration(seconds: 0),
                                      ),
                                    );
                                  },
                                  child: DivCustom(
                                      padding: [0, 0, 0, 0],
                                      width: 210,
                                      height: 53,
                                      color: this.menuClicked == 1
                                          ? "0xFFBCBCBC"
                                          : "0x00000000",
                                      child: Row(
                                        children: [
                                          ImageCustom(
                                              padding: [4, 0, 0, 15],
                                              name: this.menuClicked == 1
                                                  ? "icon_Operation_1"
                                                  : "icon_Operation",
                                              width: 25),
                                          TextCustom(
                                              padding: [15, 0, 0, 10],
                                              text: "Operation Guide",
                                              size: 16)
                                        ],
                                      ))),
                              DivCustom(
                                color: "0x33FFFFFF",
                                width: 175,
                                height: 1,
                              ),
                              GestureDetector(
                                  onTap: () {
                                    print("Read Data From DA");
//                                     showNotifyDialog(
//                                         context, '''An Error occurred during
// Reading Data. Please check
// connection with Display Audio.''');
                                    this.menuClicked = 2;
                                    DataPack dp = DataPack.initReadData();
                                    RFCommChannel.requestChannel(dp);
                                    setState(() {});
                                  },
                                  child: DivCustom(
                                      padding: [0, 0, 0, 0],
                                      width: 210,
                                      height: 53,
                                      color: this.menuClicked == 2
                                          ? "0xFFBCBCBC"
                                          : "0x00000000",
                                      child: Row(
                                        children: [
                                          ImageCustom(
                                              padding: [4, 0, 0, 15],
                                              name: this.menuClicked == 2
                                                  ? "icon_Read_1"
                                                  : "icon_Read",
                                              width: 25),
                                          TextCustom(
                                              padding: [15, 0, 0, 10],
                                              text: "Read Data From DA",
                                              size: 16)
                                        ],
                                      ))),
                              DivCustom(
                                color: "0x33FFFFFF",
                                width: 175,
                                height: 1,
                              ),
                              GestureDetector(
                                  onTap: () {
                                    this.menuClicked = 3;
                                    setState(() {});
                                    // Navigator.push(
                                    //     context,
                                    //     MaterialPageRoute(
                                    //         builder: (context) =>
                                    //             PolicyPage()));
                                    Navigator.push(
                                      context,
                                      PageRouteBuilder(
                                        pageBuilder: (_, __, ___) =>
                                            PolicyPage(),
                                        transitionDuration:
                                            Duration(seconds: 0),
                                      ),
                                    );
                                  },
                                  child: DivCustom(
                                      padding: [0, 0, 0, 0],
                                      width: 210,
                                      height: 53,
                                      color: this.menuClicked == 3
                                          ? "0xFFBCBCBC"
                                          : "0x00000000",
                                      child: Row(
                                        children: [
                                          ImageCustom(
                                              padding: [4, 0, 0, 15],
                                              name: this.menuClicked == 3
                                                  ? "icon_Policy_1"
                                                  : "icon_Policy",
                                              width: 25),
                                          TextCustom(
                                              padding: [15, 0, 0, 10],
                                              text: "Policy",
                                              size: 16)
                                        ],
                                      ))),
                            ],
                          ))
                    ]),
                  )),
          ],
        ),
      ),
    );
  }
}
