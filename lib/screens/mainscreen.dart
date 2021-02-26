import 'dart:io';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'custom/searchtap.dart';
import './custom/hometap.dart';
import '../providers/auth_provider.dart';
import '../utills/MySetting.dart';
import '../widgets/normalappbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MyDashboardActivity();
  }
}

class MyDashboardActivity extends StatefulWidget {
  @override
  _DashboardActivityState createState() => _DashboardActivityState();
}

class _DashboardActivityState extends State<MyDashboardActivity>
    with SingleTickerProviderStateMixin {
  GlobalKey _bottomNavigationKey = GlobalKey();

  @override
  void initState() {    
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  changePageValue(int val, { bool withNavBarState = false}) async {
    if (val == 0) {
      Provider.of<AuthProvider>(context, listen: false).emptyHomePage();
    } else if (val == 1) {
      await Provider.of<AuthProvider>(context, listen: false).emptySearchPage();
    }
    Provider.of<AuthProvider>(context, listen: false).changeSelectMainScreenTap(val);
    if(withNavBarState){
      final CurvedNavigationBarState navBarState = _bottomNavigationKey.currentState;
      navBarState.setPage(Provider.of<AuthProvider>(context, listen: false).selectMainScreenTap);
    }    
  }
  _getAppBar(BuildContext context) {
    String _title = '';
    if (Provider.of<AuthProvider>(context, listen: false).selectMainScreenTap == 0) {
      _title = 'All Movies';
    } else if (Provider.of<AuthProvider>(context, listen: false).selectMainScreenTap == 1) {
      _title = 'Search';
    }
    return Provider.of<AuthProvider>(context, listen: true).selectMainScreenTap == 0 ?
    NormalAppBar(
      height: 120.0,
      barTitle: _title,
      isHomeTap: Provider.of<AuthProvider>(context, listen: true).selectMainScreenTap == 0 ? true : false,
    )
    : NormalAppBar(
      height: 120.0,
      barTitle: _title,
      isHomeTap: Provider.of<AuthProvider>(context, listen: true).selectMainScreenTap == 0 ? true : false,
      onTapBack: () {
        changePageValue(0, withNavBarState: true);
      },
    );
  }

  closeAppDialog(Map<int, dynamic> myResp) {
    // Reusable alert style
    var alertStyle = AlertStyle(
      animationType: AnimationType.fromTop,
      isCloseButton: false,
      isOverlayTapDismiss: false,
      descStyle: TextStyle(
          fontSize: myResp[124],
          fontWeight: FontWeight.bold,),
      animationDuration: Duration(milliseconds: 400),
      alertBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(myResp[125]),
        side: BorderSide(
          color: Colors.grey,
        ),
      ),
      titleStyle: TextStyle(
          color: Colors.red,
          fontSize: myResp[126],),
    );
    Alert(
      style: alertStyle,
      context: context,
      type: AlertType.warning,
      title: 'Tech Stack App',
      desc: 'Are You Sure About Close This App?',
      buttons: [
        DialogButton(
          child: Text(
            'Yes',
            style: TextStyle(
                color: Colors.white,
                fontSize: myResp[127],),
          ),
          onPressed: () {
            if (Theme.of(context).platform == TargetPlatform.android) {
              SystemChannels.platform.invokeMethod('SystemNavigator.pop');
            } else if (Theme.of(context).platform == TargetPlatform.iOS) {
              exit(0);
            }
          },
          gradient: LinearGradient(
              colors: [Colors.red, Colors.red]),
        ),
        DialogButton(
          child: Text(
            'No',
            style: TextStyle(
                color: Colors.white,
                fontSize: myResp[128],),
          ),
          onPressed: () => Get.back(),
          gradient:
              LinearGradient(colors: [MySetting.mainColor, MySetting.mainColor]),
        ),
      ],
    ).show();
  }

  Future<bool> _willPopCallback(Map<int, dynamic> myResp) async {
    if (Provider.of<AuthProvider>(context, listen: false).selectMainScreenTap != 0) {
      changePageValue(0, withNavBarState: true);
      return false;
    }
    closeAppDialog(myResp);
    return false;
  }

  @override
  Widget build(BuildContext context) {
    Map<int, dynamic> myResp = getResponseve(context: context);
    final List<Widget> activity = [
      HomeTap(),
      SearchTap(),
    ];
    return SafeArea(
      child: WillPopScope(
        onWillPop: () async {
          return await _willPopCallback(myResp);
        },
        child: Scaffold(
          appBar: _getAppBar(context),
          bottomNavigationBar: CurvedNavigationBar(
            key: _bottomNavigationKey,
            index: 0,
            height: 50.0,
            items: <Widget>[
              Icon(
                Icons.home_outlined,
                size: 30,
                color: Colors.white,
              ),
              Icon(
                Icons.search,
                size: 30,
                color: Colors.white,
              ),
            ],
            color: MySetting.mainColor,
            buttonBackgroundColor: MySetting.mainColor,
            backgroundColor: Colors.transparent,
            animationCurve: Curves.easeInOut,
            animationDuration: Duration(milliseconds: 600),
            onTap: changePageValue,
          ),
          backgroundColor: Colors.grey.shade200,
          body: activity[Provider.of<AuthProvider>(context, listen: true).selectMainScreenTap] 
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
      1: 150.0, //appbar main size
      2: 120.0, //appbar normal size
      125: 0.0, // 125 BorderRadius
      126: 16.0, // 126 Text fontSize
      127: 12.0, // 127 Text fontSize
      128: 12.0, // 128 Text fontSize
    };
  } else if (isMedium1) {
    myValues = {
      1: 150.0, //appbar main size
      2: 120.0, //appbar normal size
      125: 0.0, // 125 BorderRadius
      126: 16.0, // 126 Text fontSize
      127: 12.0, // 127 Text fontSize
      128: 12.0, // 128 Text fontSize
    };
  } else if (isMedium2) {
    myValues = {
      1: 150.0, //appbar main size
      2: 120.0, //appbar normal size
      125: 0.0, // 125 BorderRadius
      126: 16.0, // 126 Text fontSize
      127: 12.0, // 127 Text fontSize
      128: 12.0, // 128 Text fontSize
    };
  } else if (isNormal) {
    if (width > height) {
      // nuxes 5 rotation
      myValues = {
        1: 165.0, //appbar main size
        2: 110.0, //appbar normal size
        125: 0.0, // 125 BorderRadius
        126: 16.0, // 126 Text fontSize
        127: 12.0, // 127 Text fontSize
        128: 12.0, // 128 Text fontSize
      };
    } else {
      myValues = {
        1: 220.0, //appbar main size
        2: 150.0, //appbar normal size
        125: 0.0, // 125 BorderRadius
        126: 16.0, // 126 Text fontSize
        127: 12.0, // 127 Text fontSize
        128: 12.0, // 128 Text fontSize
      };
    }
  } else if (isLarge) {
    // nuxes 7 rotation
    myValues = {
      1: 220.0, //appbar main size
      2: 150.0, //appbar normal size
      125: 0.0, // 125 BorderRadius
      126: 16.0, // 126 Text fontSize
      127: 12.0, // 127 Text fontSize
      128: 12.0, // 128 Text fontSize
    };
  } else if (isXlarge) {
    myValues = {
      1: 220.0, //appbar main size
      2: 170.0, //appbar normal size
      125: 0.0, // 125 BorderRadius
      126: 16.0, // 126 Text fontSize
      127: 12.0, // 127 Text fontSize
      128: 12.0, // 128 Text fontSize
    };
  }

  return myValues;
}
