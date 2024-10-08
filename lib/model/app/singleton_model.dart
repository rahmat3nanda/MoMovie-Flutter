/*
 * *
 *  * singleton_model.dart - MoMovie
 *  * Created by Rahmat Trinanda (rahmat3nanda@gmail.com) on 07/13/2024, 18:12
 *  * Copyright (c) 2024 . All rights reserved.
 *  * Last modified 07/13/2024, 17:59
 *
 */

import 'package:flutter/material.dart';
import 'package:momovie/model/movie_model.dart';

class SingletonModel {
  static SingletonModel? _singleton;

  factory SingletonModel() => _singleton ??= SingletonModel._internal();

  SingletonModel._internal();

  static SingletonModel withContext(BuildContext context) {
    _singleton ??= SingletonModel._internal();
    _singleton!.context = context;

    return _singleton!;
  }

  static SingletonModel get shared => _singleton ??= SingletonModel._internal();

  BuildContext? context;
  String? token;
  SingletonMovieModel movie = SingletonMovieModel();

  void destroy() {
    _singleton = null;
  }
}

class SingletonMovieModel {
  List<MovieModel>? nowPlaying;
  List<MovieModel>? popular;
  List<MovieModel>? topRated;
  List<MovieModel>? upcoming;
}
