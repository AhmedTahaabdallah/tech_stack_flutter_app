import 'package:flutter/material.dart';

class OneMovie {

  final String imdbID;
  final String title;
  final String year;
  final String movieType;
  final String poster;
  

  OneMovie(
    {
      @required this.imdbID,
      @required this.title, 
      @required this.year,
      @required this.movieType,
      @required this.poster,
    }
  );
}
