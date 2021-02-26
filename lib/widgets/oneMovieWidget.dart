
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:tech_stack/providers/auth_provider.dart';
import 'package:tech_stack/screens/movieDatilsScreen.dart';
import '../helper_widgets/myImageWidget.dart';
import '../models/oneMovie.dart';
import '../utills/MySetting.dart';

Widget buildOneMovie(OneMovie oneMovie, listLength, int index, { bool showYear = false}) {
  return GestureDetector(
    onTap: () async{
      await Provider.of<AuthProvider>(Get.context, listen: false).initAllMovieDetils(oneMovie.title, oneMovie.poster);
      Get.to(() => MovieDetailsScreen(movieId: oneMovie.imdbID,));
    },
    child: Container(
      padding: EdgeInsets.all(10.0),
      margin: EdgeInsets.only(
        bottom: listLength - 1 == index ?
        0 : 10.0
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black26, width: 1.0),
        borderRadius: BorderRadius.circular(8.0)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          MyImageWidget(
            imagePath: oneMovie.poster,
            width: double.infinity,
            height: MediaQuery.of(Get.context).size.height * 0.5,
            boxFit: BoxFit.contain,
          ),
          SizedBox(
            height: 5.0,
          ),
          Text(oneMovie.title,
          style: TextStyle(
            color: MySetting.mainColor,
            fontSize: 16.0
          ),),
          SizedBox(
            height: showYear ? 5.0 : 0.0,
          ),
          showYear ? 
          Text(oneMovie.year,
          style: TextStyle(
            color: Colors.black,
            fontSize: 14.0
          ),)
          : Container(),
        ],
      ),
    ),
  );
}