import 'dart:async';
import 'package:animated_widgets/animated_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../utills/MySetting.dart';
import '../providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'mainscreen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen();

  @override
  State<StatefulWidget> createState() {
    return SplashScreenState();
  }
}

class SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  bool _enabled = false;
  bool _finishDisplay = false;

  @override
  void dispose() {
    super.dispose();
  }

  void getAllPrefrence() async {
    String _myImagesPlaceHolderPath = '';
    String _platFormType = '';
    if (Theme.of(Get.context).platform == TargetPlatform.android) {
      _myImagesPlaceHolderPath = 'assets/images/loading.gif';
      _platFormType = 'android';
    } else if (Theme.of(Get.context).platform == TargetPlatform.iOS) {
      _myImagesPlaceHolderPath = 'assets/images/loadingios.gif';
      _platFormType = 'iOS';
    } else if (Theme.of(Get.context).platform == TargetPlatform.fuchsia) {
      _myImagesPlaceHolderPath = 'assets/images/loading.gif';
      _platFormType = 'fuchsia';
    }
    Provider.of<AuthProvider>(Get.context, listen: false).initMyImagesPlaceHolder(_myImagesPlaceHolderPath);
    Provider.of<AuthProvider>(Get.context, listen: false).changeAllAppPlatFormType(_platFormType);
    Provider.of<AuthProvider>(Get.context, listen: false).initAllYears();
  }

  @override
  void initState() {
    super.initState();
    getAllPrefrence();
    setState(() {
      _enabled = true;
    });
    Future.delayed(Duration(milliseconds: 2200)).then((value) {
      Future.delayed(Duration(milliseconds: 1400)).then((value) {
        setState(() {
          _finishDisplay = true;
        });
        Future.delayed(Duration(milliseconds: 2000)).then((value) {
          Get.offAll(MainScreen());
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Map<int, dynamic> myResp = getResponseve(context: context);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: MySetting.mainColor
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                _finishDisplay ?
                Container()
                : TranslationAnimatedWidget.tween(
                  enabled: _enabled,
                  duration: Duration(milliseconds: 3000),
                  translationDisabled: Offset(0, myResp[1]),
                  translationEnabled: Offset(0, myResp[4]),
                  child: OpacityAnimatedWidget.tween(
                      enabled: _enabled,
                      opacityDisabled: 0,
                      opacityEnabled: 1,
                      duration: Duration(milliseconds: 3000),
                      child: Container(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('guided',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 30.0,
                              fontWeight: FontWeight.w600
                            ),),
                          ],
                        ),
                      )),
                ),
                _finishDisplay ?
                Shimmer.fromColors(
                  period: Duration(milliseconds: 750),
                  baseColor: MySetting.mainColor,
                  highlightColor: Colors.white,
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('guided',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30.0,
                          fontWeight: FontWeight.w600
                        ),),
                        SizedBox(
                          height: 5.0,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 35.0,
                            ),
                            Text('doing',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 30.0,
                              fontWeight: FontWeight.w600
                            ),),
                          ],
                        ),
                      ],
                    ),
                  ),
                )
                : TranslationAnimatedWidget.tween(
                  enabled: _enabled,
                  duration: Duration(milliseconds: 3000),
                  translationDisabled: Offset(0, -myResp[1]),
                  translationEnabled: Offset(0, -myResp[4]),
                  child: OpacityAnimatedWidget.tween(
                      enabled: _enabled,
                      opacityDisabled: 0,
                      opacityEnabled: 1,
                      duration: Duration(milliseconds: 3000),
                      child: Container(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 35.0,
                            ),
                            Text('doing',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 30.0,
                              fontWeight: FontWeight.w600
                            ),),
                          ],
                        ),
                      )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/*
// on Genymotion
isSmall = width <= 330.0 ( width 320  Google Nexus S  480 x 800  ) 
isMedium 1 = width <= 410.0  ( width 360  Google Nexus 5  1080 x 1920  )
isMedium 2 = width <= 576.0  ( width 411  Google Nexus 6p  1440 x 2560  )
isNormal = width <= 768.0  ( width 600.938  Google Nexus 7  800 x 1280  )
isLarge = width <= 992.0  ( width 960.938  Sony Xperia Tablet Z  1920 x 1200  )
isXLarge = width <= 1500.0  ( width 1202  Google Nexus 10  2560 x 1600  )
*/
Map<int, dynamic> getResponseve(
    {BuildContext context, double wid = 0.0, double hieg = 0.0, bool loca}) {
  Map<int, dynamic> myValues;
  double width = 0.0;
  double height = 0.0;
  if (wid > 0.0 && hieg > 0.0) {
    width = wid;
    height = hieg;
  } else {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
  }
  //final double height = MediaQuery.of(cont).size.height;
  //final String orient = MediaQuery.of(cont).orientation.toString(,

  final bool isSmall = width <= 330.0; // small screen with portrait Orientation
  final bool isMedium1 = width <=
      410.0; // small screen with landscape Orientation and normall screen with portrait Orientation
  final bool isMedium2 = width <=
      576.0; // small screen with landscape Orientation and normall screen with portrait Orientation
  final bool isNormal = width <=
      768.0; // large screen with portrait Orientation and normall screen with landscape Orientation
  final bool isLarge = width <=
      992.0; // large screen with landscape Orientation and Xlarge screen with portrait Orientation
  final bool isXlarge =
      width <= 1550.0; // Xlarge screen with landscape Orientation

  if (isSmall) {
    myValues = {      
      1: -500.0, // 1 translationDisabled Offset dx
      2: 140.0, // 2 Container height
      3: 140.0, // 3 Container height
      4: 50.0, // 4 translationEnabled Offset dx
    };
  } else if (isMedium1) {
    myValues = {
      1: -350.0, // 1 translationDisabled Offset dx
      2: 140.0, // 2 Container height
      3: 140.0, // 3 Container height
      4: 50.0, // 4 translationEnabled Offset dx
    };
  } else if (isMedium2) {
    myValues = {
      1: -550.0, // 1 translationDisabled Offset dx
      2: 160.0, // 2 Container height
      3: 160.0, // 3 Container height
      4: 0.0, // 4 translationEnabled Offset dx
    };
  } else if (isNormal) {
    if (width > height) {
      myValues = {
        1: -500.0, // 1 translationDisabled Offset dx
        2: 140.0, // 2 Container height
        3: 140.0, // 3 Container height
        4: 50.0, // 4 translationEnabled Offset dx
      };
    } else {
      myValues = {
        1: -500.0, // 1 translationDisabled Offset dx
        2: 200.0, // 2 Container height
        3: 200.0, // 3 Container height
        4: 50.0, // 4 translationEnabled Offset dx
      };
    }
  } else if (isLarge) {
    // nuxes 7 rotation
    myValues = {
      1: -500.0, // 1 translationDisabled Offset dx
      2: 180.0, // 2 Container height
      3: 180.0, // 3 Container height
      4: 50.0, // 4 translationEnabled Offset dx
    };
  } else if (isXlarge) {
    myValues = {
      1: -500.0, // 1 translationDisabled Offset dx
      2: 250.0, // 2 Container height
      3: 250.0, // 3 Container height
      4: 50.0, // 4 translationEnabled Offset dx
    };
  }

  return myValues;
}