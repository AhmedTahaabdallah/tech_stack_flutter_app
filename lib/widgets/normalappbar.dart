import '../helper_widgets/my_loading_widget.dart';
import '../utills/MySetting.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class NormalAppBar extends StatelessWidget implements PreferredSizeWidget {
  final double height;
  final String barTitle;
  final bool isHomeTap;
  final bool isDismissed;
  final Function onTapBack;
  final Widget additionalWidget;
  final Function additionalWidgetFuncation;
  final bool addaitionalWidgetIconIsLoading;
  NormalAppBar({this.height, this.barTitle, this.isHomeTap, this.isDismissed, this.onTapBack, this.additionalWidget, this.additionalWidgetFuncation, this.addaitionalWidgetIconIsLoading});

  @override
  Widget build(BuildContext context) {
    //Map<int, dynamic> myResp = getResponseve(context: context);
    return PreferredSize(
        child: LayoutBuilder(
          builder: (context, constraints){
            final width = constraints.maxWidth * 3.5;
            return Stack(
              alignment: Alignment.bottomCenter,
              children: [                
                OverflowBox(
                  maxHeight: double.infinity,
                  maxWidth: double.infinity,
                  child: SizedBox(
                    height: width,
                    width: width,
                    child: Padding(
                      padding: EdgeInsets.only(
                        bottom: width / 2 - preferredSize.height / 2
                      ),
                      child: Container(                        
                        decoration: BoxDecoration(
                          color: MySetting.mainColor,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade500,
                              blurRadius: 6,
                              offset: Offset(0, 6)
                            )
                          ]
                        ),
                        child: Container(),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(                    
                    padding: EdgeInsets.only(
                      bottom: preferredSize.height / 1.8,
                      right: 18.0,
                      left: 18.0
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            !isHomeTap ? 
                            GestureDetector(
                              onTap: (){                              
                                onTapBack();
                              },
                              child: Icon(Icons.arrow_back_ios_outlined, 
                              color: Colors.white, size: 30.0,),
                            )
                            : Container(),
                            Text(
                              barTitle,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,),
                            ),
                            additionalWidget != null ?
                            addaitionalWidgetIconIsLoading ? 
                            Container(
                              child: Center(
                                child: myLoadingWidget(context, Colors.white),
                              ),
                            )
                            : GestureDetector(
                              onTap: additionalWidgetFuncation,
                              child: additionalWidget//Icon(additionalWidget, color: Colors.white, size: 30.0,),
                            )
                            : Container(
                              width: !isHomeTap ? 30.0 : 0.0,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
        preferredSize: preferredSize);
  }

  @override
  Size get preferredSize => Size.fromHeight(this.height);
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
      
    };
  } else if (isMedium1) {
    myValues = {
      
    };
  } else if (isMedium2) {
    myValues = {
      
    };
  } else if (isNormal) {
    if (width > height) {
      // nuxes 5 rotation
      myValues = {
        
      };
    } else {
      myValues = {
        
      };
    }
  } else if (isLarge) {
    // nuxes 7 rotation
    myValues = {
      
    };
  } else if (isXlarge) {
    myValues = {
      
    };
  }

  return myValues;
}
