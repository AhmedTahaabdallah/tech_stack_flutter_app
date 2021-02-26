import 'package:flutter/material.dart';
import '../providers/auth_provider.dart';
import 'package:provider/provider.dart';
//import 'package:image_fade/image_fade.dart';

class MyImageWidget extends StatelessWidget {
  final String imagePath;
  final BoxFit boxFit;
  final double height;
  final double width;
  MyImageWidget(
      {this.imagePath: '',
      this.boxFit: BoxFit.contain,
      this.height: double.infinity,
      this.width: double.infinity});
  @override
  Widget build(BuildContext context) {
    Widget _image = Container();
    try {
      _image = FadeInImage.memoryNetwork(
        placeholder: Provider.of<AuthProvider>(context, listen: true)
            .myImagesPlaceHolder,
        image: imagePath,
        height: height,
        width: width,
        fadeInDuration: Duration(milliseconds: 500),
        fadeOutDuration: Duration(milliseconds: 200),
        fit: boxFit,
        imageErrorBuilder: (context, object, track) {
          return _image = Image.asset(
            'assets/images/error.png',
            fit: boxFit,
            height: height,
            width: width,
          );
        },
      );
    } catch (err) {
      _image = Image.asset(
        'assets/images/error.png',
        fit: boxFit,
        height: height,
        width: width,
      );
    }
    return _image;
  }
}
