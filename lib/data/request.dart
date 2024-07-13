/*
 * *
 *  * request.dart - MoMovie
 *  * Created by Rahmat Trinanda (rahmat3nanda@gmail.com) on 07/13/2024, 18:27
 *  * Copyright (c) 2024 . All rights reserved.
 *  * Last modified 07/13/2024, 18:26
 *
 */

import 'package:dio/dio.dart' as dio;
import 'package:momovie/data/repo.dart';

late Repo _repo;

class Request {
  late RequestGenre genre;

  Request() {
    _repo = Repo();
    genre = RequestGenre();
  }
}

class RequestGenre {
  Future<dio.Response> movie() {
    return _repo.genre.movie();
  }
}
