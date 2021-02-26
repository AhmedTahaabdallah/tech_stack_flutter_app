import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:flutter_spinkit/flutter_spinkit.dart';
//import '../utills/MySetting.dart';

Widget myLoadingWidget(BuildContext context, Color color, {double size = 0.0}){
  double _mySize = 0.0;
  if(size == 0.0){
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    if(width <= 330.0){
      _mySize = 20.0;
    } else if(width <= 410.0){
      _mySize = 25.0;
    } else if(width <= 576.0){
      _mySize = 30.0;
    } else if(width <= 768.0){
      if(width > height){
        _mySize = 25.0;
      } else{
        _mySize = 40.0;
      }
    } else if(width <= 992.0){
      _mySize = 40.0;
    } else if(width <= 1550.0){
      _mySize = 40.0;
    } else{
      _mySize = 25.0;
    }
  }
  return /*Center(child: Container(
    decoration: BoxDecoration(
      color: MySetting.mainColor,
      shape: BoxShape.circle
    ),
    height: size == 0 ? _mySize * 1.25 : size * 1.25,
    width: size == 0 ? _mySize * 1.25 : size * 1.25,
    child: CupertinoBreathe()))*/Center(
    child: SpinKitFadingCircle(
      color: color,
      size: size == 0 ? _mySize : size,
    ),
  );
}






class CupertinoBreathe extends StatefulWidget {
  @override
  _CupertinoBreatheState createState() => _CupertinoBreatheState();
}

class _CupertinoBreatheState extends State<CupertinoBreathe>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AspectRatio(
        aspectRatio: 1.0,
        child: CustomPaint(
          painter: _BreathePainter(
              CurvedAnimation(parent: _controller, curve: Curves.ease)),
          size: Size.infinite,
        ),
      ),
    );
  }
}

class _BreathePainter extends CustomPainter {
  _BreathePainter(
    this.animation, {
    this.count = 6,
    Color color = const Color(0xFF7ACFE4),
  })  : circlePaint = Paint()
          ..color = color
          ..blendMode = BlendMode.screen,
        super(repaint: animation);

  final Animation<double> animation;
  final int count;
  final Paint circlePaint;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = (size.shortestSide * 0.25) * animation.value;
    for (int index = 0; index < count; index++) {
      final indexAngle = (index * math.pi / count * 2);
      final angle = indexAngle + (math.pi * 1.5 * animation.value);
      final offset = Offset(math.sin(angle), math.cos(angle)) * radius * 0.985;
      canvas.drawCircle(center + offset * animation.value, radius, circlePaint);
    }
  }

  @override
  bool shouldRepaint(_BreathePainter oldDelegate) =>
      animation != oldDelegate.animation;
}
