import 'package:get/get.dart';
import '../../widgets/oneMovieWidget.dart';
import '../../helper_widgets/my_loading_widget.dart';
import '../../utills/MySetting.dart';

import '../../providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeTap extends StatefulWidget {
  @override
  _HomeTapState createState() => _HomeTapState();
}

class _HomeTapState extends State<HomeTap> {
  String _error = '';
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero).then((value) {
      Provider.of<AuthProvider>(context, listen: false)
          .getAllMovies()
          .then((value) {
        if (value['status'] == 'notdone') {
          _error = value['msg'];
        }
      });
    });
  }

  bool _handleScrollNotification(BuildContext context, ScrollNotification notification) {
    if (notification is ScrollEndNotification) {
      if (notification.metrics.extentAfter == 0) {
        if(!Provider.of<AuthProvider>(context, listen: false).isLoadingAllMoviesMore
        && !Provider.of<AuthProvider>(context, listen: false).isLastAllMoviesPage){
          Provider.of<AuthProvider>(context, listen: false).getAllMovies(withMore: true).then((value) {
            if (value['status'] == 'notdone') {
              setState(() {
                _error = value['msg'];
              });
            }
          });        
        } else {
          print('this is end');
        }
      }
    }
    return false;
  }

  void _showYearsDialog() {
    showDialog(
      context: context,
      builder: (cxt) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: Text(
                'Select Year',
                textAlign: TextAlign.start,
                style: TextStyle(),
              ),
            ),
            SizedBox(
              width: 30.0,
              child: FlatButton(
                padding: EdgeInsets.all(0.0),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Theme.of(context).primaryColor),
                  ),
                  child: Icon(Icons.close, color: Theme.of(context).primaryColor, size: 25.0,),
                ),
                onPressed: () => Get.back(),
              ),
            ),
          ],
        ),
        content: Container(
          width: MediaQuery.of(context).size.width * 0.5,
          height: MediaQuery.of(context).size.height * 0.6,
          child: Column(
            children: <Widget>[
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: Provider.of<AuthProvider>(context, listen: true).allYears.
                    asMap().map((index, year){
                      return MapEntry(index, 
                        GestureDetector(
                          onTap: () async{
                            await Provider.of<AuthProvider>(Get.context, listen: false).changeAllMoviesSelectYear(year);
                            Provider.of<AuthProvider>(Get.context, listen: false).getAllMovies().then((value) {
                              if (value['status'] == 'notdone') {
                                _error = value['msg'];
                              }
                            });
                            Get.back();
                          },
                          child: Container(
                            margin: EdgeInsets.all(8.0),
                            child: Text(year,
                            style: TextStyle(
                              fontSize: 16.0,
                              color: year == Provider.of<AuthProvider>(context, listen: true).allMoviesSelectYear ?
                              MySetting.mainColor : Colors.black
                            ),),
                          ),
                        )
                      );
                    }).values.toList(),
                  ),
                ),
              ),
            ],
          ),
        )
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Provider.of<AuthProvider>(context, listen: true).isLoadingAllMovies
        ? Center(child: myLoadingWidget(context, MySetting.mainColor))
        : _error.length > 0
        ? Center(
          child: Text(
            _error,
            style: TextStyle(color: Colors.black, fontSize: 14.0),
          ),
        )
        : Provider.of<AuthProvider>(context, listen: true).allMovies.length == 0
        ? Center(
          child: Text(
            'No Movies for this year.',
            style: TextStyle(color: Colors.black, fontSize: 14.0),
          ),
        )
        : Container(
          padding: EdgeInsets.symmetric(
              vertical: 12.0,
            ),
          child: Column(
            children: [
              Expanded(
                child: NotificationListener<ScrollNotification>(
                  onNotification: (scrNotific) {
                    return _handleScrollNotification(context,scrNotific);
                  },
                  child: ListView.builder(
                    controller: scrollController,
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.0
                    ),
                    shrinkWrap: true,
                    itemCount: Provider.of<AuthProvider>(context, listen: true).allMovies.length,
                    itemBuilder: (BuildContext context, int index) {
                      return buildOneMovie(
                        Provider.of<AuthProvider>(context, listen: true).allMovies[index],
                        Provider.of<AuthProvider>(Get.context, listen: true).allMovies.length,
                        index
                      );
                    },
                  ),
                ),
              ),
              Provider.of<AuthProvider>(context, listen: false).isLoadingAllMoviesMore ?
              Container(
                margin: EdgeInsets.symmetric(
                  vertical: 25.0
                ),
                child: myLoadingWidget(context, MySetting.mainColor),
              ) :Container()
            ],
          ),
        ),
        Provider.of<AuthProvider>(context, listen: true).isLoadingAllMovies 
        ||Provider.of<AuthProvider>(context, listen: true).isLoadingAllMoviesMore ?
        Container()
        : Align(
          alignment: Alignment.bottomRight,
          child: GestureDetector(
            onTap: () {
              _showYearsDialog();
            },
            child: Container(
              width: 50.0,
              height: 50.0,
              margin: EdgeInsets.only(
                bottom: 20.0,
                right: 20.0
              ),
              padding: EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                color: MySetting.mainColor,
                shape: BoxShape.circle
              ),
              child: Icon(Icons.calendar_today, color: Colors.white, size: 30,),
            ),
          ),
        )
      ],
    );
  }
}
