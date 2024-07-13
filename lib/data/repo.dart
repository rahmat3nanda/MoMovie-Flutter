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

  Repo() {
    _api = API();
    _dio = Dio();
    genre = RepoGenre();
  }
}

class RepoGenre {
  Future<dio.Response> data() async {
    return await _dio.get(url: _api.genre.movie);
  }
}
