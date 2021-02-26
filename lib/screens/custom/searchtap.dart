import 'package:get/get.dart';
import '../../widgets/oneMovieWidget.dart';
import '../../helper_widgets/my_loading_widget.dart';
import '../../utills/MySetting.dart';

import '../../providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchTap extends StatefulWidget {
  @override
  _SearchTapState createState() => _SearchTapState();
}

class _SearchTapState extends State<SearchTap> {
  String _error = '';
  ScrollController scrollController = ScrollController();
  TextEditingController _searchControler = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  _search(String keySearch, bool withMore) {
    Provider.of<AuthProvider>(context, listen: false).getAllMoviesSearch(
      keySearch, withMore: withMore).then((value) {
      if (value['status'] == 'notdone') {
        setState(() {
          _error = value['msg'];
        });
      }
    }); 
  }

  bool _handleScrollNotification(BuildContext context, ScrollNotification notification) {
    if (notification is ScrollEndNotification) {
      if (notification.metrics.extentAfter == 0) {
        if(!Provider.of<AuthProvider>(context, listen: false).isLoadingAllMoviesSearchMore
        && !Provider.of<AuthProvider>(context, listen: false).isLastAllMoviesPageSearch){
          _search(Provider.of<AuthProvider>(context, listen: false).keySearch, true);    
        } else {
          print('this is end');
        }
      }
    }
    return false;
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          vertical: 12.0,
          horizontal: 10.0
        ),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: TextField(
              controller: _searchControler,
              onSubmitted: (val) {
                FocusScope.of(context).requestFocus(FocusNode());
                if (_searchControler.text.trim().length > 0) {
                  _search(_searchControler.text.trim(), false);  
                }
              },
              decoration: InputDecoration(
                suffixIcon: GestureDetector(
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                  if (_searchControler.text.trim().length > 0) {
                    _search(_searchControler.text.trim(), false);  
                  }
                },
                child: Icon(Icons.search)),
                hoverColor: Colors.red,
                fillColor: Colors.redAccent,
                hintText: 'Movie Name',
                contentPadding: EdgeInsets.all(12.0),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide: BorderSide(color: MySetting.mainColor, width: 1.0)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide: BorderSide(color: MySetting.mainColor, width: 1.0)),
                disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide: BorderSide(color: MySetting.mainColor, width: 1.0)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide: BorderSide(color: MySetting.mainColor, width: 1.0)),
              ),
            ),
          ),
          Expanded(
            child: Provider.of<AuthProvider>(context, listen: true).isLoadingAllMoviesSearch
          ? Center(child: myLoadingWidget(context, MySetting.mainColor))
          : _error.length > 0
          ? Center(
            child: Text(
              _error,
              style: TextStyle(color: Colors.black, fontSize: 14.0),
            ),
          )
          : Provider.of<AuthProvider>(context, listen: true).allMoviesSearch.length == 0
          ? Center(
            child: 
            Text(              
              Provider.of<AuthProvider>(context, listen: true).keySearch.trim().length == 0 ?
              'you can search for movies..'
              : 'There are no results for the search result ( ' + Provider.of<AuthProvider>(context, listen: true).keySearch + ' )',
              style: TextStyle(color: Colors.black, fontSize: 14.0),
            ),
          )
          : NotificationListener<ScrollNotification>(
              onNotification: (scrNotific) {
                return _handleScrollNotification(context,scrNotific);
              },
              child: ListView.builder(
                controller: scrollController,
                padding: EdgeInsets.symmetric(
                  
                ),
                shrinkWrap: true,
                itemCount: Provider.of<AuthProvider>(context, listen: true).allMoviesSearch.length,
                itemBuilder: (BuildContext context, int index) {
                  return buildOneMovie(
                    Provider.of<AuthProvider>(context, listen: true).allMoviesSearch[index],
                    Provider.of<AuthProvider>(Get.context, listen: true).allMoviesSearch.length,
                    index,
                    showYear: true
                  );
                },
              ),
            ),
          ),
          Provider.of<AuthProvider>(context, listen: false).isLoadingAllMoviesSearchMore ?
          Container(
            margin: EdgeInsets.symmetric(
              vertical: 25.0
            ),
            child: myLoadingWidget(context, MySetting.mainColor),
          ) :Container()
        ],
      ),
    );
  }
}
