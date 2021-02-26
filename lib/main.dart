import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:get/get.dart';
import './utills/MySetting.dart';
import 'package:provider/provider.dart';
import './screens/splashscreen.dart';
import 'providers/auth_provider.dart';

void main() async {  
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  changeStatusBar(BuildContext context) async {
    await FlutterStatusbarcolor.setStatusBarColor(MySetting.mainColor);
    FlutterStatusbarcolor.setStatusBarWhiteForeground(true);
    if (Theme.of(context).platform == TargetPlatform.android) {
      await FlutterStatusbarcolor.setNavigationBarColor(Colors.black38);
    }
  }

  @override
  Widget build(BuildContext context) {
    changeStatusBar(context);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => AuthProvider(),
        ),
      ],
      builder: (BuildContext ctx, Widget child) {
        return GetMaterialApp(
          initialRoute: '/',
          getPages: [
            GetPage(name: '/', page: () => SplashScreen()),
          ],
          navigatorKey: Get.key,
          builder: (BuildContext context, Widget child) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
              child: Material(
                type: MaterialType.transparency,
                elevation: 0,
                child: Directionality(
                  textDirection: TextDirection.ltr,
                  child: child,
                ),
              ),
            );
          },
          debugShowCheckedModeBanner: false,
          title: 'Tech Stack App',
          locale: Locale('en'), //localizationDelegate.currentLocale,
          theme: ThemeData(
            unselectedWidgetColor: Colors.white,
            disabledColor: Colors.white,
            toggleableActiveColor: Colors.white,
            scaffoldBackgroundColor: Colors.white,
            floatingActionButtonTheme: FloatingActionButtonThemeData(
              backgroundColor: MySetting.mainColor,
            ),
            primaryColor: MySetting.mainColor,
            primarySwatch: Colors.blue,
            accentColor: MySetting.subColor,
          ),
        );
      },
    );
  }
}
