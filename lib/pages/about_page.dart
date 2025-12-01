import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:xiangyue/utils/screen_util.dart';
import 'package:xiangyue/widgets/custom/div_custom.dart';
import 'package:xiangyue/widgets/custom/image_custom.dart';
import 'package:xiangyue/widgets/custom/text_custom.dart';
import 'package:provider/provider.dart';
import 'package:xiangyue/model/theme_setting.dart';

class AboutPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AboutPageState();
  }
}

class _AboutPageState extends State<AboutPage> {
  @override
  void initState() {
    super.initState();
  }

  void dispose() {
    super.dispose();
  }

  Widget _buildBody() {
    return Stack(
      children: [
        Positioned(
            top: getSize(20),
            left: getSize(20),
            child: GestureDetector(
              onTapDown: (e) {
                print("touch back");
                Navigator.pop(context);
              },
              child: ImageCustom(name: "icon_fanhui", width: 23.5),
            )),
        Positioned(
          //拉丝背景图
          top: getSize(64),
          left: 0,
          right: 0,
          bottom: 0,
          child: DivCustom(
              padding: [0, 0, 0, 0],
              child: ImageCustom(
                width: 375,
                height: 1750,
                name: Provider.of<ThemeSettings>(context, listen: true)
                    .getBackgroundImageName(),
                boxFit: BoxFit.fill,
              )),
        ),
        Positioned(
            //页面标题
            top: getSize(90),
            left: 0,
            right: 0,
            height: getSize(22),
            child: TextCustom(
              text: "Version Info",
              color: "#ffffffff",
              size: 21.5,
              weight: FontWeight.w500,
            )),
        Positioned(
          top: getSize(110),
          left: 0,
          right: 0,
          child: TextCustom(
              margin: [200, 20, 50, 20],
              padding: [0, 5, 0, 5],
              text: "DA Remote 2",
              size: 23),
        ),
        Positioned(
          top: getSize(160),
          left: 0,
          right: 0,
          child: TextCustom(
              margin: [200, 20, 50, 20],
              padding: [0, 5, 0, 5],
              text: "Version 1.1.4",
              size: 23),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Provider.of<ThemeSettings>(context, listen: false)
          .getBackgroundColor(),
      body: DivCustom(
          padding: [MediaQuery.of(context).padding.top, 0, 0, 0],
          child: _buildBody()),
    );
  }
}
