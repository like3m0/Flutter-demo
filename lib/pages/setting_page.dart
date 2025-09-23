import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:xiangyue/model/theme_setting.dart';
import 'package:xiangyue/widgets/custom/div_custom.dart';
import 'package:xiangyue/widgets/custom/image_custom.dart';
import 'package:provider/provider.dart';
import 'package:xiangyue/utils/screen_util.dart';
import 'package:flustars/flustars.dart';

class SettingPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SettingPageState();
  }
}

class _SettingPageState extends State<SettingPage> {
  int choosedIndex = -1;
  @override
  void initState() {
    super.initState();
    this.choosedIndex =
        Provider.of<ThemeSettings>(context, listen: false).themeIndex;
  }

  void dispose() {
    super.dispose();
  }

  Widget _buildBody(BuildContext ctx) {
    var h = ScreenUtil.getScreenH(ctx);
    var w = ScreenUtil.getScreenW(ctx);
    var margin = 10;
    var width = 330.0;
    if (w / h > 0.52) {
      margin = 0;
      width = 310;
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        GestureDetector(
            onTap: () {
              print("tap black");
              if (this.choosedIndex == 0) return;
              Provider.of<ThemeSettings>(context, listen: false)
                  .setSettingIndex(0);
              this.choosedIndex = 0;
              setState(() {});
            },
            child: DivCustom(
              margin: [0, 20, 0, 20],
              width: width,
              height: width / 3,
              child: Stack(
                children: [
                  // ImageCustom(
                  //     width: 335,
                  //     height: 110,
                  //     boxFit: BoxFit.fill,
                  //     name: "setting_bg"),
                  ImageCustom(
                      // padding: [12.5, 12.5, 12.5, 12.5],
                      width: width.toDouble(),
                      height: width / 3,
                      boxFit: BoxFit.fill,
                      name: this.choosedIndex == 0 ? "setting1_1" : "setting1"),
                  // if (this.choosedIndex == 0)
                  //   Container(
                  //     margin:
                  //         EdgeInsets.only(left: getSize(10), top: getSize(5)),
                  //     //设置 child 居中
                  //     alignment: Alignment(0, 0),
                  //     height: getSize(100),
                  //     width: getSize(314),
                  //     //边框设置
                  //     decoration: new BoxDecoration(
                  //       //背景
                  //       color: Colors.transparent,
                  //       //设置四周圆角 角度
                  //       borderRadius:
                  //           BorderRadius.all(Radius.circular(getSize(20))),
                  //       //设置四周边框
                  //       border: new Border.all(width: 2, color: Colors.white),
                  //     ),
                  //   ),
                ],
              ),
            )),
        GestureDetector(
            onTap: () {
              print("tap blue");
              if (this.choosedIndex == 1) return;
              Provider.of<ThemeSettings>(context, listen: false)
                  .setSettingIndex(1);
              this.choosedIndex = 1;
              setState(() {});
            },
            child: DivCustom(
              margin: [5 + margin, 20, 0, 20],
              width: width,
              height: width / 3,
              child: Stack(
                children: [
                  // ImageCustom(
                  //     width: 335,
                  //     height: 110,
                  //     boxFit: BoxFit.fill,
                  //     name: "setting_bg"),
                  ImageCustom(
                      // padding: [12.5, 12.5, 12.5, 12.5],
                      width: width.toDouble(),
                      height: width / 3,
                      boxFit: BoxFit.fill,
                      name: this.choosedIndex == 1 ? "setting2_1" : "setting2"),
                  // if (this.choosedIndex == 1)
                  //   Container(
                  //     margin:
                  //         EdgeInsets.only(left: getSize(10), top: getSize(5)),
                  //     //设置 child 居中
                  //     alignment: Alignment(0, 0),
                  //     height: getSize(100),
                  //     width: getSize(314),
                  //     //边框设置
                  //     decoration: new BoxDecoration(
                  //       //背景
                  //       color: Colors.transparent,
                  //       //设置四周圆角 角度
                  //       borderRadius:
                  //           BorderRadius.all(Radius.circular(getSize(20))),
                  //       //设置四周边框
                  //       border: new Border.all(width: 2, color: Colors.white),
                  //     ),
                  //   ),
                ],
              ),
            )),
        GestureDetector(
            onTap: () {
              print("tap green");
              if (this.choosedIndex == 2) return;
              Provider.of<ThemeSettings>(context, listen: false)
                  .setSettingIndex(2);
              this.choosedIndex = 2;
              setState(() {});
            },
            child: DivCustom(
              margin: [5 + margin, 20, 0, 20],
              width: width,
              height: width / 3,
              child: Stack(
                children: [
                  // ImageCustom(
                  //     width: 335,
                  //     height: 110,
                  //     boxFit: BoxFit.fill,
                  //     name: "setting_bg"),
                  ImageCustom(
                      // padding: [12.5, 12.5, 12.5, 12.5],
                      width: width.toDouble(),
                      height: width / 3,
                      boxFit: BoxFit.fill,
                      name: this.choosedIndex == 2 ? "setting3_1" : "setting3"),
                  // if (this.choosedIndex == 2)
                  //   Container(
                  //     margin:
                  //         EdgeInsets.only(left: getSize(10), top: getSize(5)),
                  //     //设置 child 居中
                  //     alignment: Alignment(0, 0),
                  //     height: getSize(100),
                  //     width: getSize(314),
                  //     //边框设置
                  //     decoration: new BoxDecoration(
                  //       //背景
                  //       color: Colors.transparent,
                  //       //设置四周圆角 角度
                  //       borderRadius:
                  //           BorderRadius.all(Radius.circular(getSize(20))),
                  //       //设置四周边框
                  //       border: new Border.all(width: 2, color: Colors.white),
                  //     ),
                  //   ),
                ],
              ),
            )),
        GestureDetector(
          onTap: () {
            print("tap red");
            if (this.choosedIndex == 3) return;
            Provider.of<ThemeSettings>(context, listen: false)
                .setSettingIndex(3);
            this.choosedIndex = 3;
            setState(() {});
          },
          child: DivCustom(
            margin: [5 + margin, 20, 0, 20],
            width: width,
            height: width / 3,
            child: Stack(
              children: [
                // ImageCustom(
                // width: 335,
                // height: 110,
                // boxFit: BoxFit.fill,
                // name: "setting_bg"),
                ImageCustom(
                    width: width.toDouble(),
                    height: width / 3,
                    boxFit: BoxFit.fill,
                    name: this.choosedIndex == 3 ? "setting4_1" : "setting4"),
                // if (this.choosedIndex == 3)
                //   Container(
                //     margin: EdgeInsets.only(left: getSize(10), top: getSize(5)),
                //     //设置 child 居中
                //     alignment: Alignment(0, 0),
                //     height: getSize(100),
                //     width: getSize(314),
                //     //边框设置
                //     decoration: new BoxDecoration(
                //       //背景
                //       color: Colors.transparent,
                //       //设置四周圆角 角度
                //       borderRadius:
                //           BorderRadius.all(Radius.circular(getSize(20))),
                //       //设置四周边框
                //       border: new Border.all(width: 2, color: Colors.white),
                //     ),
                //   ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0x00000000),
      body: DivCustom(padding: [30, 0, 0, 0], child: _buildBody(context)),
    );
  }
}
