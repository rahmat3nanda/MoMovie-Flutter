/*
 * *
 *  * repo.dart - MoMovie
 *  * Created by Rahmat Trinanda (rahmat3nanda@gmail.com) on 07/13/2024, 18:22
 *  * Copyright (c) 2024 . All rights reserved.
 *  * Last modified 07/13/2024, 18:12
 *
 */

import 'package:momovie/data/API.dart';
import 'package:momovie/data/dio.dart';
import 'package:dio/dio.dart' as dio;

late API _api;
late Dio _dio;

class Repo {
  late RepoGenre genre;
  late RepoMovie movie;

  Repo() {
    _api = API();
    _dio = Dio();
    genre = RepoGenre();
    movie = RepoMovie();
  }
}

class RepoGenre {
  Future<dio.Response> movie() async {
    return await _dio.get(url: _api.genre.movie);
  }
}

class RepoMovie {
  Future<dio.Response> nowPlaying({required Map<String, dynamic> param}) async {
    return await _dio.get(url: _api.movie.nowPlaying, param: param);
  }

  Future<dio.Response> popular({required Map<String, dynamic> param}) async {
    return await _dio.get(url: _api.movie.popular, param: param);
  }

  Future<dio.Response> topRated({required Map<String, dynamic> param}) async {
    return await _dio.get(url: _api.movie.topRated, param: param);
  }

  Future<dio.Response> upcoming({required Map<String, dynamic> param}) async {
    return await _dio.get(url: _api.movie.upcoming, param: param);
  }

  Future<dio.Response> search({required Map<String, dynamic> param}) async {
    return await _dio.get(url: _api.movie.search, param: param);
  }

  Future<dio.Response> movies({
    required int id,
    required Map<String, dynamic> param,
  }) async {
    return await _dio.get(url: _api.movie.movies(id), param: param);
  }

  Future<dio.Response> recommendations({
    required int id,
    required Map<String, dynamic> param,
  }) async {
    return await _dio.get(url: _api.movie.recommendations(id), param: param);
  }

  Future<dio.Response> similar({
    required int id,
    required Map<String, dynamic> param,
  }) async {
    return await _dio.get(url: _api.movie.similar(id), param: param);
  }
}
