import 'dart:ui';
import 'package:flutter/material.dart';

class MySetting{

static const defaultDuration = Duration(milliseconds: 250);
//static String myfontBold='myfontBold';


static Map<int, Color> color1 =
{
50:Color.fromRGBO(249, 135, 109,.1),
100:Color.fromRGBO(249, 135, 109,.2),
200:Color.fromRGBO(249, 135, 109,.3),
300:Color.fromRGBO(249, 135, 109,.4),
400:Color.fromRGBO(249, 135, 109,.5),
500:Color.fromRGBO(249, 135, 109,.6),
600:Color.fromRGBO(249, 135, 109,.7),
700:Color.fromRGBO(249, 135, 109,.8),
800:Color.fromRGBO(249, 135, 109,.9),
900:Color.fromRGBO(249, 135, 109,1),
};
static MaterialColor mainColor= new MaterialColor(0xFFF9876D, color1);

static Map<int, Color> color2 =
{
50:Color.fromRGBO(247, 209, 208,.1),
100:Color.fromRGBO(247, 209, 208,.2),
200:Color.fromRGBO(247, 209, 208,.3),
300:Color.fromRGBO(247, 209, 208,.4),
400:Color.fromRGBO(247, 209, 208,.5),
500:Color.fromRGBO(247, 209, 208,.6),
600:Color.fromRGBO(247, 209, 208,.7),
700:Color.fromRGBO(247, 209, 208,.8),
800:Color.fromRGBO(247, 209, 208,.9),
900:Color.fromRGBO(247, 209, 208,1),
};
static MaterialColor subColor= new MaterialColor(0xFFF7D1D0, color2);

}