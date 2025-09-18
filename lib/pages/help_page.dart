import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:xiangyue/utils/screen_util.dart';
import 'package:xiangyue/widgets/custom/div_custom.dart';
import 'package:xiangyue/widgets/custom/image_custom.dart';
import 'package:xiangyue/widgets/custom/text_custom.dart';
import 'package:provider/provider.dart';
import 'package:xiangyue/model/theme_setting.dart';

class HelpPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HelpPageState();
  }
}

class _HelpPageState extends State<HelpPage> {
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
              onTap: () {
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
              text: "How to use",
              color: "#ffffffff",
              size: 21.5,
              weight: FontWeight.w500,
            )),
        Positioned(
          top: getSize(125),
          left: 0,
          bottom: 0,
          right: 0,
          child: DivCustom(
            margin: [0, 20, 50, 20],
            padding: [0, 5, 0, 5],
            child: ClipRRect(
              borderRadius: BorderRadius.circular(getSize(22)),
              child: DivCustom(
                  color: Provider.of<ThemeSettings>(context, listen: false)
                      .getBackgroundColorString(),
                  padding: [15, 15, 15, 15],
                  child: CustomScrollView(
                    scrollDirection: Axis.vertical,
                    slivers: [
                      SliverToBoxAdapter(
                          child: SizedBox(
                        width: getSize(295),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Control your Display Audio remotely from your phone.",
                                textAlign: TextAlign.start,
                                textDirection: TextDirection.ltr,
                                maxLines: 10,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    height: 1.3,
                                    fontWeight: FontWeight.w400),
                              ),
                              DivCustom(height: 15),
                              Text(
                                "This app. allows you to control your Display Audio intuitively via Bluetooth connection.",
                                textAlign: TextAlign.left,
                                maxLines: 10,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    height: 1.3,
                                    fontWeight: FontWeight.w400),
                              ),
                              DivCustom(height: 30),
                              Text(
                                "Functions",
                                textAlign: TextAlign.start,
                                textDirection: TextDirection.ltr,
                                maxLines: 10,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    height: 1.3,
                                    fontWeight: FontWeight.w400),
                              ),
                              DivCustom(height: 15),
                              Text(
                                "1. Change mode",
                                textAlign: TextAlign.start,
                                textDirection: TextDirection.ltr,
                                maxLines: 10,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    height: 1.3,
                                    fontWeight: FontWeight.w400),
                              ),
                              DivCustom(height: 5),
                              Text(
                                "2. Volume control",
                                textAlign: TextAlign.start,
                                textDirection: TextDirection.ltr,
                                maxLines: 10,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    height: 1.3,
                                    fontWeight: FontWeight.w400),
                              ),
                              DivCustom(height: 5),
                              Text(
                                "3. Next/Previous Track (when button is tapped)",
                                textAlign: TextAlign.start,
                                textDirection: TextDirection.ltr,
                                maxLines: 10,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    height: 1.3,
                                    fontWeight: FontWeight.w400),
                              ),
                              DivCustom(height: 5),
                              Text(
                                "4. Fast Forward/Rewind (when button is tapped and hold)",
                                textAlign: TextAlign.start,
                                textDirection: TextDirection.ltr,
                                maxLines: 10,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    height: 1.3,
                                    fontWeight: FontWeight.w400),
                              ),
                              DivCustom(height: 5),
                              Text(
                                "5. Sound setting (Setting Fader/Balance, Adjusting Bass/Treble, Equalizer Setting)",
                                textAlign: TextAlign.start,
                                textDirection: TextDirection.ltr,
                                maxLines: 10,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    height: 1.3,
                                    fontWeight: FontWeight.w400),
                              ),
                              DivCustom(height: 5),
                              Text(
                                "For more detail information, please access to the link in below http://www.alpine-asia.com/en/oem/honda/24",
                                textAlign: TextAlign.start,
                                textDirection: TextDirection.ltr,
                                maxLines: 10,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    height: 1.3,
                                    fontWeight: FontWeight.w400),
                              ),
                              DivCustom(height: 30),
                              Text(
                                "Caution",
                                textAlign: TextAlign.start,
                                textDirection: TextDirection.ltr,
                                maxLines: 10,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    height: 1.3,
                                    fontWeight: FontWeight.w400),
                              ),
                              DivCustom(height: 15),
                              Text(
                                "- Please turn on Bluetooth when using this application",
                                textAlign: TextAlign.start,
                                textDirection: TextDirection.ltr,
                                maxLines: 10,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    height: 1.3,
                                    fontWeight: FontWeight.w400),
                              ),
                              DivCustom(height: 5),
                              Text(
                                "- This app is not guaranteed to work on every device",
                                textAlign: TextAlign.start,
                                textDirection: TextDirection.ltr,
                                maxLines: 10,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    height: 1.3,
                                    fontWeight: FontWeight.w400),
                              ),
                              DivCustom(height: 5),
                              Text(
                                "- The size of screen and buttons are subject to change due to screen size of the installed phones",
                                textAlign: TextAlign.start,
                                textDirection: TextDirection.ltr,
                                maxLines: 10,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    height: 1.3,
                                    fontWeight: FontWeight.w400),
                              ),
                              DivCustom(height: 10),
                            ]),
                      ))
                    ],
                  )),
            ),
          ),
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
