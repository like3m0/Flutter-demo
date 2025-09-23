import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flustars/flustars.dart';
import 'package:auto_orientation_v2/auto_orientation_v2.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:xiangyue/bluetooth/audio_status.dart';
import 'package:xiangyue/localizations.dart';
import 'package:xiangyue/pages/main_index_page.dart';
import 'package:provider/provider.dart';

import 'model/theme_setting.dart';
import 'bluetooth/audio_status.dart';

final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();
List<Locale> an = [
  const Locale('zh', 'CH'),
  const Locale('en', 'US'),
];
List<Locale> ios = [
  const Locale('en', 'US'),
  const Locale('zh', 'CH'),
];
void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarDividerColor: null,
      systemNavigationBarIconBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark));
  //return runApp(MyApp());
  return runApp(MultiProvider(
    child: MyApp(),
    providers: [
      ChangeNotifierProvider(create: (_) => ThemeSettings()),
      ChangeNotifierProvider(create: (_) => AudioStatus()),
    ],
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    AutoOrientation.portraitUpMode();
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = window.physicalSize.width;
    var screenHeight = window.physicalSize.height;
    var designHeight = 375 * screenHeight / screenWidth;
    setDesignWHD(375, designHeight, density: 1);
    print("sw:$screenWidth, sh:$screenHeight, dh: $designHeight");
    // setDesignWHD(375, 750, density: 1);
    // SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top]);
     SystemChrome.setEnabledSystemUIMode(
           SystemUiMode.manual,
           overlays: [SystemUiOverlay.top],
         );
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'DA Remote II',
      theme: ThemeData(
        platform: TargetPlatform.iOS, // 该属性可使页面右划返回
        primarySwatch: Colors.orange,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        ChineseCupertinoLocalizations.delegate,
      ],
      supportedLocales: Platform.isIOS ? ios : an,
      locale: Locale('zh'),
      home: MainIndexPage(),
    );
  }
}
