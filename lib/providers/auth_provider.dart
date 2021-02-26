import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import '../models/oneMovie.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'global_config.dart';

class AuthProvider with ChangeNotifier {
  bool _easyLoading = false;

  bool get easyLoading {
    return _easyLoading;
  }

  void changeEasyLoading(bool lang) {
    _easyLoading = lang;
    notifyListeners();
  }

  Uint8List _myImagesPlaceHolder;

  Uint8List get myImagesPlaceHolder {
    return _myImagesPlaceHolder;
  }

  void initMyImagesPlaceHolder(String imagePatth) async {
    _myImagesPlaceHolder =
        (await rootBundle.load(imagePatth)).buffer.asUint8List();
    notifyListeners();
  }

  bool _networkWork = false;

  bool get networkWork {
    return _networkWork;
  }

  Future<bool> netWorkWorking() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      _networkWork = true;
      notifyListeners();
      return _networkWork;
    } else {
      _networkWork = false;
      notifyListeners();
      return _networkWork;
    }
  }

  String _platFormType = '';

  String get platFormType {
    return _platFormType;
  }

  void changeAllAppPlatFormType(String val) {
    _platFormType = val;
    //notifyListeners();
  }

  int _selectMainScreenTap = 0;

  int get selectMainScreenTap {
    return _selectMainScreenTap;
  }

  void changeSelectMainScreenTap(int val) {
    _selectMainScreenTap = val;
    notifyListeners();
  }

  bool _isLoadingAllMovies = false;

  bool get isLoadingAllMovies {
    return _isLoadingAllMovies;
  }

  bool _isLoadingAllMoviesMore = false;

  bool get isLoadingAllMoviesMore {
    return _isLoadingAllMoviesMore;
  }

  bool _isLastAllMoviesPage = false;

  bool get isLastAllMoviesPage {
    return _isLastAllMoviesPage;
  }

  List<OneMovie> _allMovies = [];

  List<OneMovie> get allMovies {
    return _allMovies;
  }

  String _allMoviesSelectYear = '2020';

  String get allMoviesSelectYear {
    return _allMoviesSelectYear;
  }

  List<String> _allYears = [];

  List<String> get allYears {
    return _allYears;
  }

  void initAllYears({bool withYearsList = true}) {
    DateTime now = new DateTime.now();
    String currentYear = DateFormat('yyyy').format(now);
    _allMoviesSelectYear = currentYear;
    if (withYearsList) {
      int cYear = int.parse(currentYear);
      for (int i = cYear; i >= 1900; i--) {
        _allYears.add(i.toString());
      }
    }
  }

  Future<Null> changeAllMoviesSelectYear(String val) async {
    _allMoviesSelectYear = val;
    notifyListeners();
  }

  int _allMoviesSelectPage = 1;

  int get allMoviesSelectPage {
    return _allMoviesSelectPage;
  }

  void changeAllMoviesSelectPage(int val) {
    _allMoviesSelectPage = val;
    notifyListeners();
  }

  Future<Null> emptyHomePage() async {
    _allMovies = [];
    _isLoadingAllMovies = true;
    _isLoadingAllMoviesMore = false;
    _isLastAllMoviesPage = false;
    initAllYears(withYearsList: false);
    notifyListeners();
  }

  Future<Map<dynamic, dynamic>> getAllMovies({bool withMore = false}) async {
    try {
      if (!withMore) {
        _allMovies = [];
        _isLoadingAllMovies = true;
        _isLastAllMoviesPage = false;
        _allMoviesSelectPage = 1;
      } else {
        _isLoadingAllMoviesMore = true;
      }
      notifyListeners();
      bool _neteorkk = await netWorkWorking();
      if (!_neteorkk) {
        if (!withMore) {
          _isLoadingAllMovies = false;
        } else {
          _isLoadingAllMoviesMore = false;
        }
        notifyListeners();
        return {
          'status': 'notdone',
          'msg': 'Please Connect to Internet !',
        };
      }
      String query = r"""
        query ($year: String, $page: String) {
          getAllMovies(year:$year, page:$page)
            {
                imdbID
                title
                year
                movieType
                poster
            }
        }
      """;
      int finalPage = 1;
      if (withMore) {
        finalPage = _allMoviesSelectPage + 1;
      } else {
        finalPage = _allMoviesSelectPage;
      }
      Response res = await Dio()
          .post(allAppApiConfig['graphqlEndpoint'] + 'graphql',
              data: {
                'query': query,
                'variables': {
                  'year': _allMoviesSelectYear,
                  'page': finalPage.toString()
                }
              },
              options: Options(validateStatus: (status) => status >= 200))
          .catchError((onError) {
        print('onError : ' + onError.toString());
      });
      //print('getAllMovies res : ' + res.data['data'].toString());
      if (res.statusCode == 200 || res.statusCode == 201) {
        List<dynamic> _list = res.data['data']['getAllMovies'];
        for (int i = 0; i < _list.length; i++) {
          OneMovie _oneMovie = OneMovie(
            imdbID: _list[i]['imdbID'],
            title: _list[i]['title'],
            year: _list[i]['year'],
            movieType: _list[i]['movieType'],
            poster: _list[i]['poster'],
          );
          _allMovies.add(_oneMovie);
        }
        if (_list.length == 10) {
          _allMoviesSelectPage++;
        } else {
          _isLastAllMoviesPage = true;
        }
      }
      if (!withMore) {
        _isLoadingAllMovies = false;
      } else {
        _isLoadingAllMoviesMore = false;
      }
      notifyListeners();
      return {
        'status': 'done',
        'msg': '',
      };
    } catch (err) {
      if (!withMore) {
        _isLoadingAllMovies = false;
      } else {
        _isLoadingAllMoviesMore = false;
      }
      notifyListeners();
      return {
        'status': 'notdone',
        'msg': 'Data processing error',
      };
    }
  }

  bool _isLoadingAllMoviesSearch = false;

  bool get isLoadingAllMoviesSearch {
    return _isLoadingAllMoviesSearch;
  }

  bool _isLoadingAllMoviesSearchMore = false;

  bool get isLoadingAllMoviesSearchMore {
    return _isLoadingAllMoviesSearchMore;
  }

  bool _isLastAllMoviesPageSearch = false;

  bool get isLastAllMoviesPageSearch {
    return _isLastAllMoviesPageSearch;
  }

  List<OneMovie> _allMoviesSearch = [];

  List<OneMovie> get allMoviesSearch {
    return _allMoviesSearch;
  }

  int _allMoviesSelectPageSearch = 1;

  int get allMoviesSelectPageSearch {
    return _allMoviesSelectPageSearch;
  }

  String _keySearch = '';

  String get keySearch {
    return _keySearch;
  }

  void changeAllMoviesSelectPageSearch(int val) {
    _allMoviesSelectPageSearch = val;
    notifyListeners();
  }

  Future<Null> emptySearchPage() async {
    _allMoviesSearch = [];
    _isLoadingAllMoviesSearch = false;
    _isLastAllMoviesPageSearch = false;
    _isLoadingAllMoviesSearchMore = false;
    _keySearch = '';
    notifyListeners();
  }

  Future<Map<dynamic, dynamic>> getAllMoviesSearch(String kSearch,
      {bool withMore = false}) async {
    try {
      if (!withMore) {
        _allMoviesSearch = [];
        _isLoadingAllMoviesSearch = true;
        _isLastAllMoviesPageSearch = false;
        _allMoviesSelectPageSearch = 1;
        _keySearch = kSearch;
      } else {
        _isLoadingAllMoviesSearchMore = true;
      }
      notifyListeners();
      bool _neteorkk = await netWorkWorking();
      if (!_neteorkk) {
        if (!withMore) {
          _isLoadingAllMoviesSearch = false;
        } else {
          _isLoadingAllMoviesSearchMore = false;
        }
        notifyListeners();
        return {
          'status': 'notdone',
          'msg': 'Please Connect to Internet !',
        };
      }
      String query = r"""
        query ($keySearch: String, $page: String) {
          searchByName(keySearch:$keySearch, page:$page)
          {
              imdbID
              title
              year
              movieType
              poster
          }
        }
      """;
      int finalPage = 1;
      if (withMore) {
        finalPage = _allMoviesSelectPageSearch + 1;
      } else {
        finalPage = _allMoviesSelectPageSearch;
      }
      Response res = await Dio()
          .post(allAppApiConfig['graphqlEndpoint'] + 'graphql',
              data: {
                'query': query,
                'variables': {
                  'keySearch': kSearch,
                  'page': finalPage.toString()
                }
              },
              options: Options(validateStatus: (status) => status >= 200))
          .catchError((onError) {
        print('onError : ' + onError.toString());
      });
      if (res.statusCode == 200 || res.statusCode == 201) {
        //print('searchByName res : ' + res.data['data'].toString());
        List<dynamic> _list = res.data['data']['searchByName'];
        for (int i = 0; i < _list.length; i++) {
          OneMovie _oneMovie = OneMovie(
            imdbID: _list[i]['imdbID'],
            title: _list[i]['title'],
            year: _list[i]['year'],
            movieType: _list[i]['movieType'],
            poster: _list[i]['poster'],
          );
          _allMoviesSearch.add(_oneMovie);
        }
        if (_list.length == 10) {
          _allMoviesSelectPageSearch++;
        } else {
          _isLastAllMoviesPageSearch = true;
        }
      }
      if (!withMore) {
        _isLoadingAllMoviesSearch = false;
      } else {
        _isLoadingAllMoviesSearchMore = false;
      }
      notifyListeners();
      return {
        'status': 'done',
        'msg': '',
      };
    } catch (err) {
      if (!withMore) {
        _isLoadingAllMoviesSearch = false;
      } else {
        _isLoadingAllMoviesSearchMore = false;
      }
      notifyListeners();
      return {
        'status': 'notdone',
        'msg': 'Data processing error',
      };
    }
  }

  bool _isLoadingMovieDetils = false;

  bool get isLoadingMovieDetils {
    return _isLoadingMovieDetils;
  }

  Map<String, dynamic> _allMovieDetils = {};

  Map<String, dynamic> get allMovieDetils {
    return _allMovieDetils;
  }

  Future<Null> initAllMovieDetils(String title, String poster) async {
    _allMovieDetils = {
      'error': null,
      'imdbID': '',
      'title': title,
      'movieType': '',
      'year': '',
      'poster': poster,
      'released': '',
      'runtime': '',
      'language': '',
      'country': '',
      'genre': '',
      'actors': '',
      'plot': '',
    };
    _isLoadingMovieDetils = true;
    notifyListeners();
  }

  Future<Map<dynamic, dynamic>> getMovieDetils(String movieId) async {
    try {
      _isLoadingMovieDetils = true;
      notifyListeners();
      bool _neteorkk = await netWorkWorking();
      if (!_neteorkk) {
        _isLoadingMovieDetils = false;
        notifyListeners();
        return {
          'status': 'notdone',
          'msg': 'Please Connect to Internet !',
        };
      }
      String query = r"""
        query ($movieId: String) {
          getMovieDetailsById(movieId:$movieId)
          {
              error
              imdbID
              title
              movieType
              year
              poster
              released
              runtime
              language
              country
              genre
              actors
              plot   
          }
        }
      """;
      Response res = await Dio()
          .post(allAppApiConfig['graphqlEndpoint'] + 'graphql',
              data: {
                'query': query,
                'variables': {'movieId': movieId}
              },
              options: Options(validateStatus: (status) => status >= 200))
          .catchError((onError) {
        print('onError : ' + onError.toString());
      });
      //print('getMovieDetailsById res : ' + res.data['data'].toString());
      if (res.statusCode == 200 || res.statusCode == 201) {
        //print('popularProducts res : ' + res.data['data'].toString());
        Map<dynamic, dynamic> _data = res.data['data']['getMovieDetailsById'];
        if (_data['error'] == null) {
          _allMovieDetils['imdbID'] = _data['imdbID'];
          _allMovieDetils['title'] = _data['title'];
          _allMovieDetils['movieType'] = _data['movieType'];
          _allMovieDetils['year'] = _data['year'];
          _allMovieDetils['poster'] = _data['poster'];
          _allMovieDetils['released'] = _data['released'];
          _allMovieDetils['runtime'] = _data['runtime'];
          _allMovieDetils['language'] = _data['language'];
          _allMovieDetils['country'] = _data['country'];
          _allMovieDetils['genre'] = _data['genre'];
          _allMovieDetils['actors'] = _data['actors'];
          _allMovieDetils['plot'] = _data['plot'];
        } else {
          _allMovieDetils['error'] = _data['error'];
        }
      }
      _isLoadingMovieDetils = false;
      notifyListeners();
      return {
        'status': 'done',
        'msg': '',
      };
    } catch (err) {
      _isLoadingMovieDetils = false;
      notifyListeners();
      return {
        'status': 'notdone',
        'msg': 'Data processing error',
      };
    }
  }
}
