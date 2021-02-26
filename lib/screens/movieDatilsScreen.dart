import 'package:auto_animated/auto_animated.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:tech_stack/helper_widgets/myImageWidget.dart';
import 'package:tech_stack/helper_widgets/my_loading_widget.dart';
import 'package:tech_stack/providers/auth_provider.dart';
import 'package:tech_stack/utills/MySetting.dart';
import 'package:tech_stack/widgets/normalappbar.dart';

class MovieDetailsScreen extends StatefulWidget {
  final String movieId;
  MovieDetailsScreen({this.movieId});
  @override
  _MovieDetailsScreenState createState() => _MovieDetailsScreenState();
}

class _MovieDetailsScreenState extends State<MovieDetailsScreen> {
  String _error = '';

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero).then((value) {
      Provider.of<AuthProvider>(Get.context, listen: false).getMovieDetils(widget.movieId).then((value) {
        if(value['status'] == 'notdone') {
          _error = value['msg'];
        }
        setState(() {
          
        });
      });
    });
  }

  Widget _buildPosterAndTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        MyImageWidget(
          imagePath: Provider.of<AuthProvider>(Get.context, listen: true).allMovieDetils['poster'],
          width: double.infinity,
          height: MediaQuery.of(Get.context).size.height * 0.5,
          boxFit: BoxFit.contain,
        ),
        SizedBox(
          height: 5.0,
        ),
        Container(
          padding: EdgeInsets.only(
            right: 10.0,
            left: 10.0
          ),
          child: Text(Provider.of<AuthProvider>(Get.context, listen: true).allMovieDetils['title'],
          style: TextStyle(
            color: MySetting.mainColor,
            fontSize: 16.0
          ),),
        ),
      ],
    );
  }

  List<Widget> _buildLoadingSection() {
    return [
      SizedBox(
        height: MediaQuery.of(Get.context).size.height * 0.15,
      ),
      Center(
        child: myLoadingWidget(context, MySetting.mainColor),
      ),
    ];
  }

  Widget _buildOneItem(String key, String value) {
    return value == '' || value == 'N/A' ?
    Container()
    : Column(
      children: [
        RichText(text: TextSpan(
          text: key + ' : ',
          style: TextStyle(color: MySetting.mainColor, fontSize: 16.0),
          children: <TextSpan>[
            TextSpan(text: value, style: TextStyle(color: Colors.black, fontSize: 14.0),),
          ]
        )),
        SizedBox(
          height: 10.0,
        )
      ],
    );
  }

  List<Widget> _buildBodySection() {
    return [
      SizedBox(
        height: Provider.of<AuthProvider>(Get.context, listen: true).allMovieDetils['error'] != null
        || _error.length > 0 ?
        MediaQuery.of(Get.context).size.height * 0.15 : 10.0,
      ),
      Provider.of<AuthProvider>(Get.context, listen: true).allMovieDetils['error'] != null
      || _error.length > 0 ?
      Center(
        child: Text(_error.length > 0 ?
        _error : Provider.of<AuthProvider>(Get.context, listen: true).allMovieDetils['error'],
        style: TextStyle(
          color: Colors.black,
          fontSize: 14.0
        ),),
      )
      : Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildOneItem(
            'Year',
            Provider.of<AuthProvider>(Get.context, listen: true).allMovieDetils['year']
          ),
          _buildOneItem(
            'Type',
            Provider.of<AuthProvider>(Get.context, listen: true).allMovieDetils['movieType']
          ),
          _buildOneItem(
            'Released',
            Provider.of<AuthProvider>(Get.context, listen: true).allMovieDetils['released']
          ),
          _buildOneItem(
            'Runtime',
            Provider.of<AuthProvider>(Get.context, listen: true).allMovieDetils['runtime']
          ),
          _buildOneItem(
            'Language',
            Provider.of<AuthProvider>(Get.context, listen: true).allMovieDetils['language']
          ),
          _buildOneItem(
            'Country',
            Provider.of<AuthProvider>(Get.context, listen: true).allMovieDetils['country']
          ),
          _buildOneItem(
            'Actors',
            Provider.of<AuthProvider>(Get.context, listen: true).allMovieDetils['actors']
          ),
          _buildOneItem(
            'Genre',
            Provider.of<AuthProvider>(Get.context, listen: true).allMovieDetils['genre']
          ),
          _buildOneItem(
            'Plot',
            Provider.of<AuthProvider>(Get.context, listen: true).allMovieDetils['plot']
          ),
        ],
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: NormalAppBar(
          height: 120.0,
          barTitle: 'Movie Details',
          isHomeTap: false,
          onTapBack: () {
            Get.back();
          },
        ),
        backgroundColor: Colors.grey.shade200,
        body: SingleChildScrollView(
          child: Column(
            children: [
              _buildPosterAndTitle(),
              Provider.of<AuthProvider>(Get.context, listen: true).isLoadingMovieDetils ?
              Column(
                children: _buildLoadingSection(),
              )
              : Container(                                  
                child: LiveList(
                  showItemInterval: Duration(milliseconds: 80),
                  itemBuilder: (cxt, index, animation) => FadeTransition(
                    child: SlideTransition(
                      child: _buildBodySection()[index],
                      position: Tween<Offset>(
                        begin: Offset(0, -0.1),
                        end: Offset.zero,
                      ).animate(CurvedAnimation(
                        parent: animation,
                        curve: Curves.easeOutCubic,
                      )),
                    ),
                    opacity: Tween<double>(begin: 0, end: 1).animate(animation),
                  ),
                  itemCount: _buildBodySection().length,
                  shrinkWrap: true,
                  padding: EdgeInsets.only(
                    bottom: 10.0,
                    right: 10.0,
                    left: 10.0
                  ),
                  physics: NeverScrollableScrollPhysics(),
                ),
              ),
            ],
          ),
        )
      ),
    );
  }
}
